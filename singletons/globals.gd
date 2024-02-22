extends Node

signal team_changed
signal vegetable_count_changed

const BASIC_VEGETABLE_SCENE: PackedScene = preload("res://items/vegetables/basic_vegetable/basic_vegetable.tscn")

var player: Player

var team:= [] as Array[Monster]

var max_team: int = 3:
	set(v):
		team_changed.emit()
		max_team = v

var vegetable_count: int = 500:
	set(v):
		vegetable_count_changed.emit()
		vegetable_count = v
	get:
		return vegetable_count

func get_game() -> Game:
	return get_tree().current_scene as Game

func is_team_full() -> bool:
	return team.size() >= max_team

func remove_from_team(monster: Monster) -> void:
	team.erase(monster)
	team_changed.emit()

func add_to_team(monster: Monster) -> void:
	if is_team_full():
		print("team is full")
		return
	team.append(monster)
	team_changed.emit()
