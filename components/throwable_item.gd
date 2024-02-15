class_name ThrowableItem
extends Node

signal item_thrown(force: Vector2)

func throw_item(force: Vector2) -> void:
	item_thrown.emit(force)
