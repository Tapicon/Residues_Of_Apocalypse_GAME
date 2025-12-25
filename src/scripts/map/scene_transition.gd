extends Area2D

@export var next_scene: String = ""
@onready var mesage:= $mesage
@onready var transition: CanvasLayer = $"../Transition"
var can_interact = false
var interagidor: Node2D

func _ready() -> void:
	mesage.visible = false
	
func _process(delta: float) -> void:
	if can_interact == true:
		interact(interagidor)
		mesage.visible = true
		
func _on_body_entered(body: Node2D) -> void:
	interagidor = body
	can_interact = true
	

func interact(body):
	if Input.is_action_pressed("interact"):
		if body.name == "Player" and owner.name != null:
			#next_scene = dependendo do boss
			transition.change_scene(next_scene)

func _on_body_exited(body: Node2D) -> void:
	can_interact = false
	mesage.visible = false
