class_name Health
extends Node

signal health_changed(health: int)
signal damaged
signal healed
signal died

@export var max_health: int = 10

var health: int:
	set(v):
		health = clampi(v, 0, max_health)
		health_changed.emit(health)
		if health == 0:
			died.emit()

func _ready() -> void:
	full_live()

func take_damage(damage: int):
	health -= damage
	damaged.emit()

func heal(amount: int):
	health += amount
	healed.emit()

func full_live() -> void:
	health = max_health

func is_full_health() -> bool:
	return health >= max_health
