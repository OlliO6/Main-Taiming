@tool
class_name BadMonsterSpawn
extends Node2D

@export var possible_monster: Array[PackedScene]

func _ready() -> void:
	add_monster.call_deferred()

func _draw() -> void:
	if !Engine.is_editor_hint():
		return
	draw_circle(Vector2.ZERO, 2, Color.RED)

func add_monster() -> void:
	var monster:= get_monster()
	if owner is FightRooom:
		owner.add_evil_monster(monster)
	owner.add_child(monster)
	monster.is_evil = true

func get_monster() -> Monster:
	var monster:= possible_monster.pick_random().instantiate() as Monster
	monster.position = global_position
	return monster
