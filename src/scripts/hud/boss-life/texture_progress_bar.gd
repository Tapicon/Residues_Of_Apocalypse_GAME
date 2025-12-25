extends TextureProgressBar
@export var boss : CharacterBody2D
@onready var name_boss: Label = $name_boss
@onready var icon: Sprite2D = $icon

func _ready() -> void:
	pass
		
func _process(delta: float) -> void:
	if is_instance_valid(boss):
		icon.texture = load(boss.icon)
	if boss and is_instance_valid(boss):
		max_value = boss.max_life
		value = boss.life
		name_boss.text = boss.boss_name
	else:
		value = 0
