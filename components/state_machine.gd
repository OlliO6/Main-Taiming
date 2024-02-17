class_name StateMachine
extends Node

signal state_switched(to_state: State, from_state: State)

@export var start_state: State

var state: State
var prev_state: State

func _ready() -> void:
	_enter_start_state.call_deferred()
	
func _enter_start_state() -> void:
	if !is_instance_valid(state):
		switch_state(start_state)

func switch_state(to_state: State, _emit_switched:= true):
	prev_state = state
	state = to_state
	if prev_state:
		prev_state.exit()
	state.enter()
	state_switched.emit(to_state, prev_state)
