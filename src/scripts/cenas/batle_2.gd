extends Node2D
@onready var bg_sound: AudioStreamPlayer2D = $bg_sound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_random_music()

func _on_bg_sound_finished() -> void:
	play_random_music()

func play_random_music():
	GlobalMusic.current_music_index = GlobalMusic.get_random_music_index(GlobalMusic.battle_song_list)
	var music = GlobalMusic.battle_song_list[GlobalMusic.current_music_index]
	var stream = load(music["path"])
	if stream:
		bg_sound.stream = stream
		bg_sound.play()
		print("Tocando:", music["name"])
