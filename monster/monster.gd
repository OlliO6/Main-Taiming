class_name Monster
extends CharacterBody2D

@export_group("taming")
@export var vegetables_needed: int = 3

@onready var feeding_area: Area2D = $FeedingArea
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var state_machine: StateMachine = $StateMachine
@onready var taming_phase_1: State = $StateMachine/TamingPhase1
@onready var taming_phase_2: State = $StateMachine/TamingPhase2

var vegetables_feeded: int

func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	
	if state_machine.state == taming_phase_2 && event.is_action_pressed("interact") && Globals.player in feeding_area.get_overlapping_bodies():
		finish_tame()

func feed(vegetable: Vegetable) -> void:
	
	if state_machine.state == taming_phase_1:
		vegetables_feeded += vegetable.vegetables_count
		vegetable.get_parent().remove_child(vegetable)
		vegetable.queue_free()
		_update_progress_bar(0, vegetables_needed, vegetables_feeded)
		if vegetables_feeded >= vegetables_needed:
			state_machine.switch_state(taming_phase_2)

func finish_tame() -> void:
	print("FINISHED")

func _update_progress_bar(min: float, max: float, value: float) -> void:
	progress_bar.min_value = min
	progress_bar.max_value = max
	progress_bar.value = value
	#TODO: Animate progress_bar alpha

func _on_feeding_area_body_entered(body: Node2D) -> void:
	if body is Vegetable:
		feed(body)

func _on_taming_phase_2_state_entered() -> void:
	progress_bar.hide()
	$TameLabel.show()
