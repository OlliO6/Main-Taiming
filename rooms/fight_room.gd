class_name FightRooom
extends Node2D

signal cleared

var evil_monsters: int

func _ready() -> void:
	cleared.connect(Globals.get_game().end_fight)
	_start_fight.call_deferred()

func add_evil_monster(monster: Monster) -> void:
	evil_monsters += 1
	monster.defeaated.connect(_on_evil_monster_defeated)

func _start_fight() -> void:
	Globals.get_game().about_to_start_fight()
	$StartFightTimer.timeout.connect(Globals.get_game().start_fight)

func _on_evil_monster_defeated() -> void:
	evil_monsters -= 1
	if evil_monsters <= 0:
		cleared.emit()
