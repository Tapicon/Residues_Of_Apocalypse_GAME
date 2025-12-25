extends Node2D

@onready var music_alert: CanvasLayer = $music_alert
@export var next_scene : String = ""
@onready var transition : CanvasLayer= $Transition
@onready var alert : CanvasLayer = $Alert
@onready var background: AnimatedSprite2D = $Background
@onready var layout_01: Node2D = $layout_1
@onready var layout_fases: Node2D = $layout_fases
@onready var bg_sound: AudioStreamPlayer2D = $bg_sound
var musicas = ["res://assets/audio/songs/bg_souds/Wave to earth - bonfire.mp3"]
func _ready() -> void:
	randomize()
	background.play("anim_scenarie")
	layout_fases.visible = false
	alert.visible = false
	await get_tree().create_timer(1.5).timeout
	play_random_music()
	
func _on_btn_new_game_pressed() -> void:
	SaveManager.save_data["player"] = {
		
	}
	SaveManager.clear_save()
	transition.change_scene(next_scene, 0.5, 2.0)


func _on_btn_continue_pressed() -> void:
	transition.change_scene(next_scene, 0.5, 2.0)

func _jogar():
	layout_fases.on_of()

func play_random_music():
	GlobalMusic.current_music_index = GlobalMusic.get_random_music_index(GlobalMusic.menu_song_list)
	var music = GlobalMusic.menu_song_list[GlobalMusic.current_music_index]
	var stream = load(music["path"])
	if stream:
		bg_sound.stream = stream
		bg_sound.pitch_scale = float(music["pitch"])
		bg_sound.play()
		music_alert.atualizar_musica(music["name"])


func _on_sair_confirmar_pressed() -> void:
	get_tree().quit()


func _on_bg_sound_finished() -> void:
	play_random_music()
