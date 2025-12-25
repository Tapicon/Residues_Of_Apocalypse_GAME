extends Enemy

var direction = -1
var attack_direction = Vector2.ZERO

@onready var anim: AnimationPlayer = $anim
@onready var tela_vitoria: CanvasLayer = $"../tela_vitoria"
@onready var tela_morte: CanvasLayer = $"../tela_morte"
@onready var animation: AnimatedSprite2D = $animation

var batidas = 0
var point_position = Vector2(560, 62)

func _ready() -> void:
	super()
	player = $"../node_Player"
	speed = 500
	boss_name = "UrubuaS"
	anim.play('voo')
	state = 'idle'
	icon = "res://assets/sprites/layouts/icons/urubu rosto.png"
func _physics_process(delta: float) -> void:
	print("estado atual: " + str(state))

	if not is_instance_valid(player):
		return

	match state:
		"idle":
			if global_position.distance_to(point_position) < 10.0:
				state = "fly"
			else:
				direction = (point_position - global_position).normalized()
				move_towards_player()

		"fly":
			if batidas == 0:
				anim.play("voo")
			elif batidas >= 3:
				# Armazena a direção do player no momento em que começa o ataque
				attack_direction = (player.global_position - global_position).normalized()
				state = "attack"
			else:
				direction = (point_position - global_position).normalized()
				move_towards_player()

		"attack":
			direction = attack_direction  # Travar a direção do ataque
			var distance = global_position.distance_to(player.global_position)
			run_and_attack(distance)

			# Voltar para "idle" ao colidir com o chão
			if is_on_floor():
				state = "idle"
				batidas = 0

		"died":
			pass

func move_towards_player():
	if direction.x < 0:
		animation.scale.x = 2
	elif direction.x > 0:
		animation.scale.x = -2

	velocity = direction * speed
	move_and_slide()

func attack_melee():
	state = "idle"
	player._take_hit(base_damage)
	batidas = 0
	print("⚔️ Ataque Corpo a Corpo!")

func run_and_attack(distance):
	state = 'attack'
	if direction.x < 0:
		animation.scale.x = 2
	move_towards_player()
	if distance <= melee_range:
		attack_melee()

func tomar_dano(valor: int) -> void:
	life -= valor
	animation.modulate = Color(1, 0.5, 0.5, 1)

	var damage_timer = Timer.new()
	add_child(damage_timer)
	damage_timer.wait_time = 0.2
	damage_timer.one_shot = true
	damage_timer.timeout.connect(func():
		animation.modulate = Color(1, 1, 1)
		damage_timer.queue_free()
	)
	damage_timer.start()

	if life <= 0:
		morrer()

func morrer() -> void:
	state = "died"
	visible = false
	tela_vitoria.visible = true
	get_tree().paused = true

func _on_anim_animation_finished(anim_name: StringName) -> void:
	batidas += 3
