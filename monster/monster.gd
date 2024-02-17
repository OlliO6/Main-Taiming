class_name Monster
extends CharacterBody2D

signal tamed
signal defeaated

@export_group("taming")
@export var vegetables_needed: int = 3
@export var tame_outline_color: Color
@export_group("following")
@export var follow_max_player_dist: float
@export var follow_speed: float
@export_range(0, 1) var follow_damping: float
@export_group("")
@export var selected_outline_color: Color
@export var in_team_outline_color: Color
@export var knocked_outline_color: Color

@onready var interact_label: Label = $InteractLabel
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var feeding_area: Area2D = $InteractArea
@onready var state_machine: StateMachine = $StateMachine
@onready var taming_phase_1_state: State = $StateMachine/TamingPhase1
@onready var taming_phase_2_state: State = $StateMachine/TamingPhase2
@onready var preperation_state: State = $StateMachine/Preperation
@onready var knocked_out_state: State = $StateMachine/KnockedOut
@onready var sprite: Sprite2D = $Sprite
@onready var health_interface: Health = $Health
@onready var health_label: Label = $HealthLabel
@onready var interactable_interface: Interactable = $Interactable
@onready var evil_state: State = $StateMachine/Evil

var vegetables_feeded: int
var _outline_color: Color

func _ready() -> void:
	_set_outline_color(Color(0, 0, 0, 0), true)
	interact_label.hide()
	health_label.hide()
	
	interactable_interface.allow_interaction = func() -> bool:
		return taming_phase_2_state.is_active() || preperation_state.is_active()
	
	Globals.team_changed.connect(_on_team_changed)
	Globals.get_game().fight_started.connect(_on_fight_started)
	Globals.get_game().fight_ended.connect(_on_fight_ended)

func _physics_process(delta: float) -> void:
	
	match state_machine.state:
		preperation_state:
			if is_in_team():
				follow_player(delta)
			else:
				_set_anim_state("idle")

func follow_player(delta: float):
	var player_pos:= Globals.player.position
	var target_velocity: Vector2
	
	if player_pos.distance_to(position) < follow_max_player_dist:
		_set_anim_state("idle")
		target_velocity = Vector2.ZERO
	else:
		_set_anim_state("run")
		var dir:= (player_pos - position).normalized()
		target_velocity = dir * follow_speed
	
	velocity = velocity.lerp(target_velocity, (1 - follow_damping) * delta)
	move_and_slide()

func is_evil() -> bool:
	return evil_state.is_active() || (state_machine.prev_state == evil_state && knocked_out_state.is_active())

func set_evil(evil: bool) -> void:
	if state_machine.state == null:
		state_machine.start_state = evil_state if evil else taming_phase_1_state
	else:
		state_machine.switch_state(evil_state if evil else taming_phase_1_state)

func is_in_team() -> bool:
	return self in Globals.team

func feed(vegetable: Vegetable) -> void:
	
	animation_tree.set("parameters/feed/request", 1)
	
	if taming_phase_1_state.is_active():
		vegetables_feeded += vegetable.vegetables_count
		vegetable.consume()
		_update_health_label(vegetables_needed, vegetables_feeded)
		if vegetables_feeded >= vegetables_needed:
			state_machine.switch_state(taming_phase_2_state)
		return
	
	health_interface.heal(vegetable.vegetables_count)
	vegetable.consume()

func finish_tame() -> void:
	state_machine.switch_state(preperation_state)
	health_interface.full_live()
	tamed.emit()

func is_feedable() -> bool:
	match state_machine.state:
		taming_phase_1_state:
			return true
		taming_phase_2_state:
			return false
		knocked_out_state:
			return Game.game_state == Game.GameState.PREPERATION
	
	return !health_interface.is_full_health()

func _set_anim_state(state: String):
	animation_tree.set("parameters/state/transition_request", state)

func _set_outline_color(color: Color, save: bool) -> void:
	if save:
		_outline_color = color
	sprite.material.set("shader_parameter/color", color)

func _on_team_changed() -> void:
	if is_in_team():
		_set_outline_color(in_team_outline_color, true)
	elif _outline_color == in_team_outline_color:
		_set_outline_color(Color(0, 0, 0, 0), true)

func _on_interacted() -> void:
	if taming_phase_2_state.is_active():
		finish_tame()
	elif preperation_state.is_active():
		if is_in_team():
			Globals.remove_from_team(self)
		else:
			Globals.add_to_team(self)
		interact_label.text = _get_interact_label_text()

func _on_interact_area_body_entered(body: Node2D) -> void:
	
	if body is Vegetable:
		if is_feedable():
			feed(body)
		elif health_interface.is_full_health():
			create_tween().tween_property(health_label, "modulate:a", 0.0, 1).from(1.0)\
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
		return

func _get_interact_label_text() -> String:
	match state_machine.state:
		taming_phase_2_state:
			return "'e' to tame"
		
		preperation_state:
			return "'e' to " + ("exclude" if is_in_team() else "include")
		
	return ""

func _on_state_switched(to_state: State, from_state: State) -> void:
	interact_label.text = _get_interact_label_text()

func _on_taming_phase_1_state_entered() -> void:
	_update_health_label(vegetables_needed, vegetables_feeded)
	health_label.show()

func _on_taming_phase_2_state_entered() -> void:
	_set_outline_color(tame_outline_color, true)
	health_label.hide()

func _on_taming_phase_2_state_exited() -> void:
	_set_outline_color(Color(0, 0, 0, 0), true)

func _on_preperation_state_entered() -> void:
	health_label.show()
	health_interface.full_live()
	_update_health_label(health_interface.max_health, health_interface.health)

func _update_health_label(max: int, current: int) -> void:
	health_label.text = str(current) + "/" + str(max)
	health_label.modulate.a = 0 if max == current else 1

func _on_health_changed(health: int) -> void:
	_update_health_label(health_interface.max_health, health)
	
	if knocked_out_state.is_active() && health_interface.is_full_health():
		state_machine.switch_state(preperation_state)

func _on_selected() -> void:
	interact_label.show()
	_set_outline_color(selected_outline_color, false)

func _on_deselected() -> void:
	interact_label.hide()
	_set_outline_color(_outline_color, false)

func _on_knockout() -> void:
	health_label.visible = Game.game_state == Game.GameState.PREPERATION
	_set_outline_color(knocked_outline_color, true)
	animation_tree.set("parameters/state/transition_request", 2)
	defeaated.emit()

func _on_knocked_out_state_exited() -> void:
	health_label.hide()
	_set_outline_color(Color(0, 0, 0, 0), true)
	animation_tree.set("parameters/knocked_switch/transition_request", 0)

func _on_fight_started() -> void:
	pass

func _on_fight_ended() -> void:
	if knocked_out_state.is_active():
		if is_in_team():
			health_label.show()
			Globals.remove_from_team(self)
		if is_evil():
			set_evil(false)

