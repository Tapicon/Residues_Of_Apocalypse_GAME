extends Enemy
@onready var animation := $animation as AnimatedSprite2D
@onready var label := $Label as Label
const GRAVITY = 980.0
var timer_move: Timer
var attack_timer: Timer
var attack_frequency = 3
var can_attack = false  # Flag para controlar se pode atacar
var can_move = false
var direction: Vector2
@onready var tela_vitoria: CanvasLayer = $"../tela_vitoria"

func _ready() -> void:
	super()
	#valores
	player = $"../node_Player"
	boss_name = "Lobisomem Pidão"
	speed = 400
	max_life = 200
	life = max_life
	# Timer de frequência de ataque
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = attack_frequency
	attack_timer.one_shot = true
	attack_timer.timeout.connect(func():
		can_attack = true
	)
	attack_timer.start()
	timer_move = Timer.new()
	add_child(timer_move)
	timer_move.wait_time = attack_frequency
	timer_move.one_shot = true
	timer_move.timeout.connect(func():
		can_move = true
			)
	timer_move.start()
	
	
func _physics_process(delta: float) -> void:
	print(state)
	if life < 100:
		icon = "res://assets/sprites/layouts/icons/lobo_preto.png"
	if state == "idle":
			animation.play('standed')
	if is_instance_valid(player):
		if player:
			direction = (player.global_position - global_position).normalized()
		if direction.x >= 0:
			animation.flip_h = true
		else:
			animation.flip_h = false
		_apply_gravity(delta)
		atualizar_label()
		if player and can_move:
			check_player_distance()
		
	
func atualizar_label():
	label.text = "Vida: %.2f" % life  # Converte a variável para texto

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		print(velocity.y)
		move_and_slide()
		
func check_player_distance():
	if not player or not is_instance_valid(player):
		return
	var distance = global_position.distance_to(player.global_position)
	print(distance)
	if is_on_floor():
		if distance <= melee_range and can_attack:
			if state == "idle":
				state = "attacking"
				attack_melee("attacking")
		elif distance >= ranged_range and state == "idle" or state == "ombrada":
			state = "ombrada"
			run_and_attack(distance,"ombrada")
		elif distance >= melee_range and life < 199 and distance <= ranged_range:#distance < ranged_range
			state = "biting"
			run_and_attack(distance,"biting")
		elif distance <= melee_range:
			run_and_attack(distance,state)

func move_towards_player():
	velocity = direction * speed
	move_and_slide()

func attack_melee(state):
	if state == "attacking":
		animation.play("attack_base")
	elif state == "biting":
		animation.play("bite")
	elif state == "ombrada":
		animation.play("ombrada")
	if not animation.is_connected("frame_changed", self._on_attack_frame_changed):
		animation.connect("frame_changed", self._on_attack_frame_changed)
	player._take_hit(base_damage)
	print("⚔️ Ataque Corpo a Corpo!")
	can_attack = false
	can_move = false
	attack_timer.start()
	timer_move.start()
		
func run_and_attack(distance, state):
	move_towards_player()
	if distance >= melee_range:
		animation.play("movendo")
		#if not animation.is_connected("frame_changed", self._on_attack_frame_changed):
			#animation.connect("frame_changed", self._on_attack_frame_changed)
		#player._take_hit(base_damage)
		can_attack = false
	else:
		can_attack = false
		can_move = false
		attack_melee(state)
		
		#attack_timer.start()
		#timer_move.start()
	
func tomar_dano(valor: int) -> void:
	life -= valor  # Diminui a vida
	atualizar_label()  # Atualiza o texto da vida
	print("Lobisomem tomou dano! Vida restante: ", life)

	# Torna o sprite banco
	animation.modulate = Color(1, 0.5, 0.5, 1)  # Branco total

	# Criar um timer para voltar ao normal depois de 0.2 segundos
	var damage_timer = Timer.new()
	add_child(damage_timer)
	damage_timer.wait_time = 0.2
	damage_timer.one_shot = true
	damage_timer.timeout.connect(func():
		animation.modulate = Color(1, 1, 1)  # Volta ao normal
		damage_timer.queue_free()
	)
	damage_timer.start()

	if life <= 0:
		morrer()
		
func morrer() -> void:
	state = "died"
	visible = false
	tela_vitoria.visible = true
func _on_attack_frame_changed() -> void:
	if (animation.animation == "attack_base" and animation.frame == animation.sprite_frames.get_frame_count("attack_base") - 1) or (animation.animation == "bite" and animation.frame == animation.sprite_frames.get_frame_count("bite") - 1 ) or (animation.animation == "ombrada" and animation.frame == animation.sprite_frames.get_frame_count("ombrada") - 1 ):
		state = "idle"
		animation.disconnect("frame_changed", self._on_attack_frame_changed)
