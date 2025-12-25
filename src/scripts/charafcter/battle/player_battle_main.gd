extends CharacterBody2D
class_name Player
@export_category("Variables")
@export var move_speed: float = 180.0
@onready var animation := $animation as AnimatedSprite2D
@onready var layer_hud: CanvasLayer = $"../layer_HUD"
@export var direction: Vector2  # Variável exportada
@export var scale_x : float
@onready var label = $Label
@onready var enemy = null 
@onready var die_screen = $"../tela_morte"
var can_shot = true
var state = ""
var shot_script = preload("res://scripts/charafcter/battle/player_battle_attack.gd")
const GRAVITY = 980.0
const JUMP_VELOCITY = -350.0
var TIME_JUMP = 0.2
var aceleration = 0.3
var friction = 0.1
var state_can_jump = false  
var last_direction: Vector2
var atack_script = null
static var life_player = 5
var is_invincible = false
var invincible_cooldown = 0.0
var can_dash = true
var dash_range = 2000
var timer_dash : Timer
var timer_dash_invincible : Timer
@onready var run_sfx: AudioStreamPlayer2D = $run_sfx

func _ready() -> void:
	life_player = 5
	var shot_instance = shot_script.new()
	add_child(shot_instance)
	state = "idle"
	timer_dash = Timer.new()
	add_child(timer_dash)
	timer_dash.wait_time = 0.5
	timer_dash.one_shot = true
	timer_dash.timeout.connect(func():
		can_dash = true
		can_shot = true
		state = "idle"
			)
	timer_dash_invincible = Timer.new()
	add_child(timer_dash_invincible)
	timer_dash_invincible.wait_time = 0.3
	timer_dash_invincible.one_shot = true
	timer_dash_invincible.timeout.connect(func():
		is_invincible = false
			)

	
func _physics_process(delta: float) -> void:
	print("Estado " + state)
	if Input.is_action_just_pressed("kill"):
		_die()
	_apply_gravity(delta)
	if invincible_cooldown >= 0.0:
		invincible_cooldown -= delta  # Diminui o tempo de invencibilidade
		_flash_invincibility()
		if invincible_cooldown <= 0.0:
			is_invincible = false
	else:
		modulate = Color(1, 1, 1, 1)  # Restaura a transparência normal
	if state == "idle":
		animation.play("standed")
	elif state == "shotting":
		animation.play("shot")
	elif state == "dashing":
		animation.play("dash")
	elif state == "jump":
		animation.play('jump')
		
	if state == "running":
		if not run_sfx.playing:
			run_sfx.play()
	else:
		if run_sfx.playing:
			run_sfx.stop()
			run_sfx.seek(0.0)  # Reinicia o tempo do som
		
	_move()
	_jump()
	_dash()
	move_and_slide()
	atualizar_label()

func atualizar_label():
	label.text = "Vida: %0.f" % life_player  # Converte a variável para texto

func _apply_gravity(delta: float) -> void:
	if not is_on_floor() :
		if state != "dashing":
			state = "jump"
		velocity.y += GRAVITY * delta
	else:
		state_can_jump = true  # Permite pular novamente quando no chão
		
func _move() -> void:
	direction = Vector2(Input.get_axis("move_left", "move_right"),Input.get_axis("move_up","move_down"))

	# Girar o personagem 
	if direction.x != 0:
		#animation.flip_h = direction < 0 
		if direction.x == 1 :
			scale_x = 1
			animation.flip_h = false
		else:
			scale_x = -1
			animation.flip_h = true
	# Verifica se mudou de direção
	if direction != Vector2.ZERO:
		if sign(direction) != sign(last_direction):
			velocity.x = 0  # Interrompe a velocidade ao mudar de direcao
			if is_on_floor():
				state = "idle"
		else:
			if is_on_floor() and direction.x != 0 and can_dash == true:
				state = "running"
				animation.play('run')
			velocity.x = lerp(velocity.x, direction.x * move_speed, aceleration)  # Movimento suave
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)  # Aplica desaceleração
		if is_on_floor() and can_dash == true:
			state = "idle"
	if direction != Vector2.ZERO:
		last_direction = direction  # Atualiza última direção

func _jump() -> void:
	if Input.is_action_pressed("jump") and state_can_jump:
		velocity.y = JUMP_VELOCITY  # Executa o pulo imediato
		state_can_jump = false  # Desativa o pulo até tocar o chão

func _take_hit(damage: int = 1):
	if is_invincible:
		return  # Se o jogador está invencível, ele não toma dano
	life_player -= damage
	velocity += Vector2(-1000, -200)
	invincible_cooldown = 2.0
	is_invincible = true
	if life_player == 0:
		shot_script._gun_die()
		_die()
		
func _die():
	die_screen.start_animation()
	shot_script._gun_die()
	layer_hud.visible = false
	get_tree().paused = true
	queue_free()
	

func _flash_invincibility() -> void:
	# Alterna a transparência do personagem para dar o efeito de "piscar"
	@warning_ignore("integer_division")
	if int(Time.get_ticks_msec() / 100) % 2 == 0:
		modulate = Color(1, 1, 1, 0.5)  # Torna o personagem semi-transparente
	else:
		modulate = Color(1, 1, 1, 1)  # Restaura a transparência normal

func _dash():
	if Input. is_action_just_pressed("dash"):
		if can_dash == true: 
			state = "dashing"
			
			if direction.x == 0:
				if animation.flip_h:
					velocity.x = -0.4 * dash_range
				else:
					velocity.x = 0.4 * dash_range
			else:
				velocity.x = direction.x * dash_range
			can_dash = false
			can_shot = false
			is_invincible = true
			timer_dash.start()
			timer_dash_invincible.start()
