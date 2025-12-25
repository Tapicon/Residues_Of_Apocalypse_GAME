extends CanvasLayer
@onready var btn_pause: CanvasLayer = $btn_pause
@onready var node_player: CharacterBody2D = $"../node_Player"
@onready var alert: CanvasLayer = $Alert
@onready var layer_hud: CanvasLayer = $"../layer_HUD"

var can_pause = true
@onready var transition: CanvasLayer = $"../Transition"
var menu = "res://scenes/interfaes/main_menu.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	alert.visible = false
	visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(alert.visible)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_pause()

func _toggle_pause():
	if is_instance_valid(layer_hud):
		layer_hud.visible = visible
	visible = not visible
	btn_pause.visible = not visible
	btn_pause.visible = not visible
	alert.visible = visible
	get_tree().paused = visible
	
func _on_touch_screen_button_pressed() -> void:
	_toggle_pause()

func _on_touch_screen_button_2_released() -> void:
	node_player._die()
	get_tree().paused = false
	transition.change_scene(menu, 0.0, 0.0)

func _on_touch_screen_button_3_pressed() -> void:
	get_tree().paused = false
	hide()  # Esconde o menu antes de recarregar
	await get_tree().process_frame  # Espera um frame para evitar conflitos
	if is_instance_valid(node_player):
		node_player._die()
	get_tree().reload_current_scene()




func _on_pause_pressed() -> void:
	_toggle_pause()
