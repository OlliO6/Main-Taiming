class_name State
extends Node

signal state_entered
signal state_exited

@export var tags: PackedStringArray

func enter():
	emit_signal("state_entered")

func exit():
	emit_signal("state_exited")

func _entered() -> void:
	pass
	
func _exited() -> void:
	pass
