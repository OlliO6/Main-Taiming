class_name ItemHolder
extends Node2D

signal item_released(item: Node2D)

@onready var give_vegetable_timer: Timer = %GiveVegetableTimer

func _ready() -> void:
	item_released.connect(func(i):
		give_vegetable_timer.start())
	give_vegetable_timer.timeout.connect(func():
		try_pick_new_basic_vegetable()
		give_vegetable_timer.stop())

func _process(delta: float) -> void:
	
	var item:= get_item()
	# force the item into position
	if item:
		item.transform = Transform2D.IDENTITY

func is_holding_item() -> bool:
	return get_child_count() > 0

func get_item() -> Node2D:
	if is_holding_item():
		return get_child(0)
	else:
		return null

func is_holding_basic_vegetable() -> bool:
	if !is_holding_item():
		return false
	var item = get_item()
	if item is Vegetable && item.is_basic_vegetable:
		return true
	return false

func release_item(free_basic_vegetables: bool) -> Node2D:
	if !is_holding_item():
		return null
	
	if free_basic_vegetables && is_holding_basic_vegetable():
		Globals.vegetable_count += 1
		var item: Node2D = get_item()
		remove_child(item)
		item.queue_free()
		item_released.emit(null)
		return null
	
	var item: Node2D = get_item()
	remove_child(item)
	item.position = owner.global_position
	get_tree().current_scene.add_child(item)
	item_released.emit(item)
	return item

func pick_up_item(item: Node2D) -> void:
	var old_item:= release_item(true)
	
	var parent:= item.get_parent()
	if parent != null:
		parent.remove_child(item)
	item.position = Vector2.ZERO
	add_child(item)

func try_pick_new_basic_vegetable() -> void:
	if is_holding_item():
		return
	
	if Globals.vegetable_count < 1:
		return
		
	Globals.vegetable_count -= 1
	pick_up_item(Globals.BASIC_VEGETABLE_SCENE.instantiate())