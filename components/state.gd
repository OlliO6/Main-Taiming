class_name State
extends Node

signal state_entered
signal state_exited

@export var tags: PackedStringArray

func get_state_machine() -> StateMachine:
	return get_parent() as StateMachine

func is_active() -> bool:
	return get_state_machine().state == self

func enter():
	emit_signal("state_entered")

func exit():
	emit_signal("state_exited")

func _entered() -> void:
	pass
	
func _exited() -> void:
	pass
