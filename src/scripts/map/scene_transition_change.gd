extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect = $ColorRect 
	fade_out()

func change_scene(scene, delay = 1.0, waiting_time = 1.0):
	color_rect.visible = true
	var scene_transition = get_tree().create_tween()
	scene_transition.tween_property(color_rect, "modulate", Color(0, 0, 0, 1), 0.5).set_delay(delay)
	await scene_transition.finished
	await get_tree().create_timer(waiting_time).timeout
	get_tree().change_scene_to_file(scene)
	

func fade_out():
	color_rect.visible = true
	color_rect.modulate = Color(0, 0, 0, 1)  # Mantém visível para o fade-out
	var fade_out_tween = get_tree().create_tween()
	fade_out_tween.tween_property(color_rect, "modulate", Color(0, 0, 0, 0), 1.0)
	await fade_out_tween.finished
