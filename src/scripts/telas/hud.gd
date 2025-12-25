extends CanvasLayer
@export var player : CharacterBody2D
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player):
		label.text = "Vida: %0.f" % player.life_player
	if get_tree().paused == true:
		visible = false
	else:
		visible = true


func right_diagonal_pressed():
	Input.action_press("move_up")
	Input.action_press("move_right")

func right_diagonal_released():
	Input.action_release("move_up")
	Input.action_release("move_right")
	
func left_diagonal_pressed():
	Input.action_press("move_up")
	Input.action_press("move_left")

func left_diagonal_released():
	Input.action_release("move_up")
	Input.action_release("move_left")
