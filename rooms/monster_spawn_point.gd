@tool
class_name MonsterSpawn
extends Node2D

func _draw() -> void:
	if !Engine.is_editor_hint():
		return
	draw_circle(Vector2.ZERO, 2, Color.LIME_GREEN)
