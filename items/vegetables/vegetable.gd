class_name Vegetable
extends RigidBody2D

@export var is_basic_vegetable: bool = false
@export var vegetables_count: int = 1
@export var no_pick_velocity: float = 1

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	$Item.allow_pickup = func(): return linear_velocity.length() < no_pick_velocity

func on_pickup() -> void:
	Globals.vegetable_count += vegetables_count
	queue_free()

func consume() -> void:
	get_parent().remove_child(self)
	queue_free()
