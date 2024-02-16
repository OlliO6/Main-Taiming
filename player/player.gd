class_name Player
extends CharacterBody2D

@export var movement_speed: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var item_holder:= %ItemHolder as ItemHolder

func _ready() -> void:
	Globals.player = self

func _physics_process(delta: float) -> void:
	
	var input_vector: Vector2
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * movement_speed
	move_and_slide()
	animate(input_vector)

func animate(input_vector: Vector2) -> void:
	if input_vector == Vector2.ZERO:
		animation_player.play("idle")
	else:
		animation_player.play("run")
