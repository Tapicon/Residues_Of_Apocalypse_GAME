extends Enemy

const GRAVITY = 980.0
var timer_move: Timer
var attack_timer: Timer
var attack_frequency = 3
var can_attack = false  # Flag para controlar se pode atacar
var can_move = false
var direction: Vector2
@onready var tela_vitoria: CanvasLayer = $"../tela_vitoria"
@onready var animation: AnimationPlayer = $AnimationPlayer
var timer := 0.0
@onready var spikes: Sprite2D = $spinhos/spikes
var player_in_damage_area := false
@onready var node_player: Player = $"../node_Player"
@export var damage_interval: float = 1.0
@onready var sprite: Sprite2D = $sprite

func _ready() -> void:
	if is_instance_valid(spikes):
		spikes.visible = false
	super()
	icon = "res://assets/sprites/layouts/icons/tatu rosto.png"
	state = "idle"
	#valores
	player = $"../node_Player"
	boss_name = "Taturano"
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
	if can_attack:
		if life < 100:
			animation.play('spike_attack')
			can_attack = false
		else:
			animation.play('preda_attack')
			can_attack = false
	_apply_gravity(delta)
	if player_in_damage_area and node_player:
		node_player._take_hit(base_damage)


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		print(velocity.y)
		move_and_slide()
		


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:  # Se o corpo que colidiu for o jogador
		if timer == 0:
			timer = 1.1
		player_in_damage_area = true
		node_player = body 


func _on_hitbox_body_exited(body: Node2D) -> void:
	player_in_damage_area = false
	node_player = null
	timer = 0.0

func tomar_dano(valor: int) -> void:
	life -= valor  # Diminui a vida
	# Torna o sprite banco
	sprite.modulate = Color(1, 0.5, 0.5, 1)  # Branco total

	# Criar um timer para voltar ao normal depois de 0.2 segundos
	var damage_timer = Timer.new()
	add_child(damage_timer)
	damage_timer.wait_time = 0.2
	damage_timer.one_shot = true
	damage_timer.timeout.connect(func():
		sprite.modulate = Color(1, 1, 1)  # Volta ao normal
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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	can_attack = true
