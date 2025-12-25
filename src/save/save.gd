extends Node  # Isso é OBRIGATÓRIO para ser usado no AutoLoad
class_name Save_Game
var save_dir : String
var save_Path : String
#const save_Path = "res://save/save.json"
var save_data = {"player" : {}}

func _ready() -> void:
		# Verifica a plataforma
	if OS.get_name() in ["Android", "iOS"]:
		save_dir = OS.get_user_data_dir() + "/Saves/" 
	else:
		var user_name = OS.get_environment("USERNAME")  # Obtém o nome do usuário no Windows
		save_dir = "C:/Users/" + user_name + "/RoA/Saves/"  # Usa o nome do usuário para o caminho

	save_Path = save_dir + "save.json"

	print("Caminho do save:", save_Path)  # Debug para verificar o caminho

	ensure_directory()
	ensure_save_file()
	
func ensure_save_file():
	if not FileAccess.file_exists(save_Path):
		var file = FileAccess.open(save_Path, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify({}))  # Criar um JSON vazio
			file.close()

func ensure_directory():
	var dir = DirAccess.open(save_dir)
	if dir == null:
		# Cria a estrutura de pastas RoA/Saves caso não exista
		DirAccess.make_dir_recursive_absolute(save_dir)  # Cria todas as pastas necessárias
	
	# Verifica se a criação deu certo
	DirAccess.make_dir_absolute(save_dir)  # Cria a pasta se não existir
	print("Criando diretório:", save_dir)  # Depuração

func save_game():
	var file = FileAccess.open(save_Path, FileAccess.WRITE) #cria se o arquivo nao existir
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))  # Salva formatado
		file.close()

func load_game():
	if not FileAccess.file_exists(save_Path):
		return  # Se o arquivo não existe não faz nada
	
	var file = FileAccess.open(save_Path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		save_data = json.data
		
func clear_save():
	
	save_data = {"player": {}}  # Reseta os dados na memória
	
	var file = FileAccess.open(save_Path, FileAccess.WRITE) # Abre e sobrescreve
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))  # Salva formatado
		file.close()
