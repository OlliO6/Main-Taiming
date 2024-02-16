class_name Interactable
extends Node

signal interacted
signal selected
signal deselected

var allow_interaction:= func() -> bool: return true

func interact() -> void:
	interacted.emit()

func _selected() -> void:
	selected.emit()

func _deselected() -> void:
	deselected.emit()
