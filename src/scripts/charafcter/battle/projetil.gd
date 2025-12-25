extends Area2D
class_name ProjetilFogo

const SPEED = 320.0  # Velocidade do projetil
var direction : Vector2 = Vector2(1,0) # Direção que o projetil vai se mover (1 ou -1, dependendo do lado)
const LIFETIME = 3.5  # Tempo que o projetil vai durar em segundos
var timer: Timer
@onready var shot_sfx: AudioStreamPlayer2D = $shot_sfx

func _ready() -> void:
	shot_sfx.play()
	# O valor de direction será passado de outro script, como você fez
	print("Direção do projetil: ", direction)
	timer = Timer.new()
	add_child(timer)  # Adiciona o timer como um filho do projetil
	timer.wait_time = LIFETIME  # Define o tempo de vida do projetil
	timer.one_shot = true  # Garante que o timer dispara apenas uma vez
	timer.timeout.connect(_on_timer_timeout)  # Sem aspas, sem "self"
  	# Conecta o sinal de timeout a uma função
	timer.start()

func _process(delta: float) -> void:
	# Movimento do projetil de acordo com a direção
	position += SPEED * delta * direction
	
func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if body.has_method("tomar_dano"):  # Verifica se o personagem tem a função
			body.tomar_dano(1)  # Chama a função para reduzir a vida
	queue_free()
