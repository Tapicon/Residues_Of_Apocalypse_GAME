extends CanvasLayer
@export var text : String
@onready var label: Label = $text
@onready var animation: AnimationPlayer = $Animation
@export var type_alert: String
@onready var kill: AudioStreamPlayer2D = $kill
@onready var win: AudioStreamPlayer2D = $win

func _ready() -> void:
	label.text = text
	visible = false


func _process(delta: float) -> void:
	pass

func start_animation():
	animation.play("entrada")
	
func desaparecer():
	visible = not visible
	get_tree().paused = visible
	
func play_sound():
	if type_alert == null or type_alert == "":
		return
	else:
		if type_alert == "kill":
			kill.play()
		elif type_alert == "win":
			win.play()
