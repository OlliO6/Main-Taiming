class_name Item
extends Node

signal picked
signal released

func _picked() -> void:
	picked.emit()

func _released() -> void:
	released.emit()
