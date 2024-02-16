extends Area2D

@onready var item_holder: ItemHolder = %ItemHolder

func _on_body_entered(body: Node2D) -> void:
	
	var item_interface:= body.get_node_or_null("Item") as Item
	
	if item_interface && !item_interface.allow_pickup.call():
		return
	
	if body is Vegetable && body.is_basic_vegetable:
		body.on_pickup()
		return
	
	item_holder.pick_up_item(body)

func _on_body_exited(body: Node2D) -> void:
	pass
