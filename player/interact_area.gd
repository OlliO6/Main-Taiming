extends Area2D

@onready var item_holder: ItemHolder = %ItemHolder

var selected_interactable: Interactable

func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	
	if !event.is_echo() && event.is_action_pressed("interact") && is_instance_valid(selected_interactable):
		selected_interactable.interact()

func _on_body_entered(body: Node2D) -> void:
	
	var interactable_interface:= body.get_node_or_null("Interactable") as Interactable
	
	if interactable_interface:
		if  !interactable_interface.allow_interaction.call():
			return
			
		if is_instance_valid(selected_interactable):
			selected_interactable._deselected()
		selected_interactable = interactable_interface
		interactable_interface._selected()
		return
	
	var item_interface:= body.get_node_or_null("Item") as Item
	
	if item_interface:
		if  !item_interface.allow_pickup.call():
			return
			
		if body is Vegetable && body.is_basic_vegetable:
			body.on_pickup()
		else:
			item_holder.pick_up_item(body)
		return

func _on_body_exited(body: Node2D) -> void:
	var interactable_interface:= body.get_node_or_null("Interactable") as Interactable
	if interactable_interface && interactable_interface == selected_interactable:
		interactable_interface._deselected()
		selected_interactable = null
		return
