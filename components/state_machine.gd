class_name StateMachine
extends Node

signal state_switched(to_state: State, from_state: State)

@export var start_state: NodePath

var state: State
var prev_state: State

func _ready() -> void:
	switch_state.call_deferred(get_node(start_state))

func switch_state(to_state: State, _emit_switched:= true):
	prev_state = state
	state = to_state
	if prev_state:
		prev_state.exit()
	state.enter()
	state_switched.emit(to_state, prev_state)
