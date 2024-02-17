extends "res://monster/fight_logic/monster_fight_logic.gd"

@export var enemy_dist: float = 20

func _physics_process(delta: float) -> void:
	
	if Game.game_state != Game.GameState.FIGHT:
		return
	
	target = get_nearest_enemy()
	
	if !is_following() && has_target():
		_move_towards_target(delta)
	
	monster.move_and_slide()

func _move_towards_target(delta: float) -> void:
	monster.smooth_move_towards(target.position, monster.follow_speed, 0.001, enemy_dist, delta)
