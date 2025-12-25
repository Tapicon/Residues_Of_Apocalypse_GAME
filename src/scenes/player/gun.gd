extends Area2D

const PROJETIL = preload("res://scenes/projetil.tscn")

@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var player : CharacterBody2D
var direction_gun : Vector2 = Vector2(1, 0)  # Direção do tiro
var scale_x : float 
var can_shot : bool = true
var shot_cadence = 0.15
var cooldown_timer: Timer
var inactivity_timer: Timer
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Criando o timer de cooldown para o disparo
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.wait_time = shot_cadence  # Tempo de cooldown entre tiros (0.2 segundos)
	cooldown_timer.one_shot = false  # Repetir até ser desativado
	cooldown_timer.timeout.connect(_reset_shot)  # Conectar o timeout ao reset do tiro
	
	# Criando o timer de inatividade para esconder a arma
	inactivity_timer = Timer.new()
	add_child(inactivity_timer)
	inactivity_timer.wait_time = 1.0  # Tempo de inatividade antes de esconder a arma
	inactivity_timer.one_shot = true
	inactivity_timer.timeout.connect(_hide_weapon)  # Função chamada ao fim do tempo de inatividade

	# Inicializando a animação de arma invisível
	animation.visible = false  # Inicialmente, a arma não está visível
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player):
		can_shot = player.can_shot
		_shot()
	
	
func _shot():
	if player.state != "dashing":
		if animation.visible == true:
			if is_instance_valid(player):
				if player.direction.x == 0:
					player.state = "shotting"
		if scale_x == 1:
			animation.flip_h = false
		else:
			animation.flip_h = true
		#animation.scale.x == scale_x # Ajustando a escala da animação para a direção
		
		if Input.is_action_pressed('shot') and can_shot and visible:
			animation.visible = true  # Torna a arma visível
			animation.play('shot')  # Executa a animação de tiro
			
			# Instancia o projetil
			animation.rotation_degrees = 0
			var projetil_instance = PROJETIL.instantiate()
			if direction_gun == Vector2.ZERO:
				projetil_instance.direction.x = scale_x
			else:
				projetil_instance.direction = direction_gun.normalized()  # Passando a direção para o projetil
				if direction_gun.x == 1 and direction_gun.y == -1:
					animation.rotation_degrees = -40
				elif direction_gun.x == 1 and direction_gun.y == 1:
					animation.rotation_degrees = 40
				elif direction_gun.x == -1 and direction_gun.y == -1:
					animation.rotation_degrees = 40
				elif direction_gun.x == -1 and direction_gun.y == 1:
					animation.rotation_degrees = -40
				elif direction_gun.y == -1 and scale_x == 1:
					animation.rotation_degrees = -90
				elif direction_gun.y == -1 and scale_x == -1:
					animation.rotation_degrees = 90
				elif direction_gun.y == 1 and scale_x == -1:
					animation.rotation_degrees = -90
				elif direction_gun.y == 1 and scale_x == 1:
					animation.rotation_degrees = 90
			get_tree().current_scene.add_child(projetil_instance)
			projetil_instance.position = global_position  # Define a posição inicial do projetil
			projetil_instance.rotation = animation.rotation  # Mantém a rotação da arma
			player.can_shot = false  # Desabilita o disparo enquanto estiver em cooldown
			cooldown_timer.start()  # Inicia o cooldown
			inactivity_timer.start()
		elif !Input.is_action_pressed('shot') and animation.visible == true and can_shot == false:
				animation.play("standed")
	else:
		_hide_weapon()
# Função para esconder a arma após 1 segundo de inatividade
func _hide_weapon() -> void:
	animation.visible = false  # Torna a arma invisível
	# Exemplo: global_position.y -= 20  # A arma sobe 20 pixels (ajuste conforme necessário)
	
	# A arma vai desaparecer ou subir após 1 segundo de inatividade
	
	# Opcional: Resetar o timer de inatividade ao voltar a atirar
	inactivity_timer.stop()

# Função para resetar o cooldown de disparo
func _reset_shot() -> void:
	if is_instance_valid(player):
		if player.state != "dashing":
			player.can_shot = true
