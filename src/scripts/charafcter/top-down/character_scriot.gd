extends CharacterBody2D

@export_category("Variables")
@export var move_speed: float = 200.0
@onready var animation := $animation as AnimatedSprite2D
var world_position : Vector2 

var aceleration = 0.3
var friction = 0.1

func save_game_world():
	SaveManager.save_data["player"] = {
		"World_Position": [round(world_position.x), round(world_position.y)]
	}
	SaveManager.save_game()

func load_game_world():
	#Carregar jogo
	SaveManager.load_game()
	var player_data = SaveManager.save_data.get("player", {})
	if player_data:
		#armazena as cordenadas
		var cordinates = player_data.get("World_Position", [])
		if cordinates:
			#atribui as cordenadas a posição
			world_position = Vector2(cordinates[0], cordinates[1])


func _ready() -> void:
	load_game_world()
	if world_position:
		global_position = world_position
	
func _physics_process(_delta: float) -> void:
	_move()
	world_position = global_position
	save_game_world()

func _move() -> void:
	var direction: Vector2 = Vector2(
		Input.get_axis("move_left","move_right"),
		Input.get_axis("move_up","move_down")
	).normalized()
	
	var last_direction = direction
	
	if direction != Vector2.ZERO:
		if direction.x < 0:  # Movendo para a esquerda
			animation.flip_h = true
		elif direction.x > 0:  # Movendo para a direita
			animation.flip_h = false
			
	if direction != Vector2.ZERO:
		if direction != Vector2.ZERO and direction.dot(last_direction) < 0:
			velocity = lerp(velocity, Vector2.ZERO, friction)
			animation.play('standed')
		else:
			if direction.y < 0:
				animation.play("run_up")
			elif direction.y > 0:
				animation.play("run_down")
			else:
				animation.play('run')
			velocity = lerp(velocity, direction * move_speed, aceleration)# Suaviza o movimento
			last_direction = direction
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)  # Aplica desaceleração para freiar
		animation.play('standed')
	move_and_slide()

	
