class_name MonsterPlaceBorder
extends StaticBody2D

func _ready() -> void:
	Globals.get_game().fight_started.connect(set.bind("process_mode", PROCESS_MODE_DISABLED))
