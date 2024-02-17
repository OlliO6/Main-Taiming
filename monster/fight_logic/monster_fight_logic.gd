extends Node2D

@onready var monster:= get_parent() as Monster

func _ready() -> void:
	monster.fighting_state.state_entered.connect(_on_fight_enterd)
	monster.fighting_state.state_exited.connect(_on_fight_exited)

func is_fighting() -> bool:
	return monster.fighting_state.is_active()

func is_following() -> bool:
	return monster.following_player

func _on_fight_enterd():
	pass

func _on_fight_exited():
	pass
