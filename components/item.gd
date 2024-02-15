class_name Item
extends Node

signal picked
signal released

var allow_pickup:= func() -> bool: return true

func _picked() -> void:
	picked.emit()

func _released() -> void:
	released.emit()
