extends Node

signal team_changed

const BASIC_VEGETABLE_SCENE: PackedScene = preload("res://items/vegetables/basic_vegetable/basic_vegetable.tscn")

var player: Player
var vegetable_count: int = 10

var max_team: int = 3
var team:= [] as Array[Monster]

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
