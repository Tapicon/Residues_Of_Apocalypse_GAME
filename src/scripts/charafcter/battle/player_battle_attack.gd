extends CharacterBody2D

const GUN = preload("res://scenes/gun/gun.tscn")
var life :bool
@onready var player = get_node("../")  # Acessando o nó pai (jogador)
@onready var direction : Vector2
@onready var scale_x : float
static var gun_instance = null

# Distância da arma em relação ao player
var gun_offset = Vector2(13, 10)  # Distância inicial da arma para a direita

func _ready() -> void:
	add_to_group("Player")
	
func _physics_process(_delta: float) -> void:
	direction = player.direction # Obtendo a direção do jogador do script de movimentação
	scale_x = player.scale_x
	_shot()


func _shot():
	if not gun_instance:
		gun_instance = GUN.instantiate()
		get_tree().root.add_child(gun_instance)  # Adiciona a arma na árvore da cena

	# Atualiza a direção da arma
	gun_instance.direction_gun = direction
	gun_instance.player = player
	# Ajusta a posição da arma baseada na direção do player
	if scale_x >= 0:
		gun_instance.position = global_position + gun_offset  # Arma na frente (direita)
		gun_instance.scale_x = 1  # Normal
	else:
		gun_instance.position.x = global_position.x - gun_offset.x  # Arma na frente (esquerda)
		gun_instance.position.y = global_position.y + gun_offset.y
		gun_instance.scale_x = -1  # Espelhado

static func _gun_die():
	if gun_instance != null:
		gun_instance.queue_free()
	
