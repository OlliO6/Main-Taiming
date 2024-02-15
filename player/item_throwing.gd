extends Node2D

@export var shoot_strenght: float = 30

@onready var shoot_delay_timer: Timer = $ThrowDelayTimer
@onready var item_holder:= %ItemHolder as ItemHolder

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_echo():
		return
	
	if event.is_action_pressed("shoot") && shoot_delay_timer.is_stopped():
		shoot()

func shoot() -> void:
	
	var item:= item_holder.get_item()
	if !is_instance_valid(item):
		return
	var throwable:= item.get_node_or_null("ThrowableItem") as ThrowableItem
	if throwable == null:
		return
	
	shoot_delay_timer.start()
	item_holder.release_item(false)
	item.global_position = global_position
	var mouse_pos: Vector2 = get_global_mouse_position();
	item.look_at(mouse_pos);
	if item.global_position.x > mouse_pos.x:
		item.scale = Vector2(-1, -1);
		throwable.throw_item(-item.transform.x * shoot_strenght)
	else:
		throwable.throw_item(item.transform.x * shoot_strenght)
