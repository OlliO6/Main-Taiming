class_name Monster
extends CharacterBody2D

@export_group("taming")
@export var vegetables_needed: int = 3
@export var tame_outline_color: Color

@onready var interact_label: Label = $InteractLabel
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var feeding_area: Area2D = $InteractArea
@onready var state_machine: StateMachine = $StateMachine
@onready var taming_phase_1_state: State = $StateMachine/TamingPhase1
@onready var taming_phase_2_state: State = $StateMachine/TamingPhase2
@onready var preperation_state: State = $StateMachine/Preperation
@onready var sprite: Sprite2D = $Sprite
@onready var health_system: Health = $Health
@onready var health_label: Label = $HealthLabel

var vegetables_feeded: int

func _ready() -> void:
	_set_outline_color(Color(0, 0, 0, 0))
	interact_label.hide()
	health_label.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	
	if event.is_action_pressed("interact") && interact_label.visible:
		if state_machine.state == taming_phase_2_state:
			finish_tame()
		elif state_machine.state == preperation_state:
			if is_in_team():
				Globals.remove_from_team(self)
			else:
				Globals.add_to_team(self)
			interact_label.text = _get_interact_label_text()
		return

func is_in_team() -> bool:
	return self in Globals.team

func feed(vegetable: Vegetable) -> void:
	
	animation_tree.set("parameters/OneShot/request", 1)
	
	if state_machine.state == taming_phase_1_state:
		vegetables_feeded += vegetable.vegetables_count
		vegetable.consume()
		_update_health_label(vegetables_needed, vegetables_feeded)
		if vegetables_feeded >= vegetables_needed:
			state_machine.switch_state(taming_phase_2_state)
		return
	
	health_system.heal(vegetable.vegetables_count)
	vegetable.consume()

func finish_tame() -> void:
	state_machine.switch_state(preperation_state)
	health_system.full_live()

func is_feedable() -> bool:
	match state_machine.state:
		taming_phase_1_state:
			return true
		taming_phase_2_state:
			return false
	
	return !health_system.is_full_health()

func _set_outline_color(color: Color) -> void:
	sprite.material.set("shader_parameter/color", color)

func _on_interact_area_body_entered(body: Node2D) -> void:
	
	if body is Vegetable:
		if is_feedable():
			feed(body)
		return
	
	if body is Player:
		interact_label.show()

func _get_interact_label_text() -> String:
	match state_machine.state:
		taming_phase_2_state:
			return "'e' to tame"
		
		preperation_state:
			return "'e' to " + ("exclude" if is_in_team() else "include")
		
	return ""

func _on_state_switched(to_state: State, from_state: State) -> void:
	interact_label.text = _get_interact_label_text()

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body is Player:
		interact_label.hide()

func _on_taming_phase_1_state_entered() -> void:
	_update_health_label(vegetables_needed, vegetables_feeded)
	health_label.show()

func _on_taming_phase_2_state_entered() -> void:
	_set_outline_color(tame_outline_color)
	health_label.hide()

func _on_preperation_state_entered() -> void:
	health_label.show()
	health_system.full_live()
	_update_health_label(health_system.max_health, health_system.health)

func _update_health_label(max: int, current: int) -> void:
	health_label.text = str(current) + "/" + str(max)

func _on_health_changed(health: int) -> void:
	_update_health_label(health_system.max_health, health)

