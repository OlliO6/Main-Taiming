class_name Player
extends CharacterBody2D

@export var movement_speed: float

func _physics_process(delta: float) -> void:
	
	var input_vector: Vector2
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * movement_speed
	move_and_slide()
