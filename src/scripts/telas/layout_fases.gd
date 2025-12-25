extends Node2D

@onready var transition: CanvasLayer = $Transition

@onready var btn_lobisone: TouchScreenButton = $Background/HBoxContainer/btn_lobisone
@onready var btn_urubua: TouchScreenButton = $Background/HBoxContainer/btn_urubua
@onready var btn_tautu: TouchScreenButton = $Background/HBoxContainer/btn_tautu

func _ready() -> void:

	# Define os caminhos das cenas nas metas
	btn_lobisone.set_meta("scene", "res://scenes/phase/batle.tscn")
	btn_urubua.set_meta("scene", "res://scenes/phase/batle_2.tscn")
	btn_tautu.set_meta("scene", "res://scenes/phase/battle_3.tscn")

	# Conecta cada botão e passa ele mesmo como argumento
	btn_lobisone.pressed.connect(_on_button_pressed.bind(btn_lobisone))
	btn_urubua.pressed.connect(_on_button_pressed.bind(btn_urubua))
	btn_tautu.pressed.connect(_on_button_pressed.bind(btn_tautu))

func _on_button_pressed(button: TouchScreenButton) -> void:
	if button.has_meta("scene"):
		var cena = button.get_meta("scene")
		trocar_cena(cena)

func trocar_cena(scene_path: String) -> void:
	transition.change_scene(scene_path, 0.5, 2.0)

func on_of():
	visible = not visible
