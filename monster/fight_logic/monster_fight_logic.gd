extends Node2D

@onready var monster:= get_parent() as Monster

var target: Monster

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	_setup.call_deferred()

func has_target() -> bool:
	return is_instance_valid(target)

func is_fighting() -> bool:
	return monster.fighting_state.is_active()

func is_following() -> bool:
	return monster.following_player

func get_nearest_enemy() -> Monster:
	var enemies:= get_tree().get_nodes_in_group("monster")
	
	var result: Monster = null
	var smallest_sqrt_dist: float = INF
	
	for m: Monster in enemies:
		if m.is_evil == monster.is_evil || m.knocked_out_state.is_active():
			continue
		var sqrt_dist = global_position.distance_squared_to(m.global_position)
		if sqrt_dist < smallest_sqrt_dist:
			smallest_sqrt_dist = sqrt_dist
			result = m
	return result

func _setup() -> void:
	monster.fighting_state.state_entered.connect(_on_fight_enterd)
	monster.fighting_state.state_exited.connect(_on_fight_exited)
	monster.follow_started.connect(_on_follow_started)
	monster.follow_ended.connect(_on_follow_ended)

func _on_follow_started() -> void:
	pass
	
func _on_follow_ended() -> void:
	pass

func _on_fight_enterd():
	process_mode = Node.PROCESS_MODE_INHERIT
	monster.velocity = Vector2.ZERO

func _on_fight_exited():
	process_mode = Node.PROCESS_MODE_DISABLED
