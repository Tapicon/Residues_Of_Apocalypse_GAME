extends CharacterBody2D

class_name Enemy
@export var boss_name: String = "base_name"
@export var icon: String = "res://assets/sprites/layouts/icons/icon_lobo01.png"
@export var max_life : int = 100
@export var base_damage: int = 1
@export var enemy_stage: int = 1
@export var speed: int = 50
@export var state: String = "idle"
@export var life: int
@export var melee_range: float = 100.0  # Distância para ataque corpo a corpo
@export var ranged_range: float = 300.0  # Distância para ataque à distância
@onready var player:CharacterBody2D = null

func _ready() -> void:
	life = max_life


func _process(delta):
	pass
