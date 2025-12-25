extends CanvasLayer
@onready var lbl_music: Label = $lbl_music
@onready var animation: AnimationPlayer = $lbl_music/Animation

func _ready() -> void:
	lbl_music.visible = false
func atualizar_musica(song_name):
	lbl_music.text = song_name
	animation.play("fade_in_out")
