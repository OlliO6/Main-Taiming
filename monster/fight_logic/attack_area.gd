extends Area2D

signal attack_began
signal attcked

@export var damage: int = 1
@export var attack_time: float
@export var time_between_attacks: float
@export var fight_logic: Node

var is_attacking: bool
var ready_to_attack: bool

var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.autostart = false
	add_child(_timer)
	Globals.get_game().fight_started.connect(_on_fight_started)

func _physics_process(delta: float) -> void:
	if ready_to_attack && !is_attacking && fight_logic.target in get_overlapping_bodies():
		_begin_attack()

func _on_fight_started() -> void:
	_timer.timeout.connect(_get_ready, CONNECT_ONE_SHOT)
	_timer.start(time_between_attacks)

func _get_ready() -> void:
	ready_to_attack = true

func _begin_attack() -> void:
	is_attacking = true
	_timer.timeout.connect(_attack, CONNECT_ONE_SHOT)
	_timer.start(attack_time)
	attack_began.emit()

func _attack() -> void:
	if fight_logic.target in get_overlapping_bodies():
		var health:= fight_logic.target.get_node("Health") as Health
		if health:
			health.take_damage(damage)
	
	attcked.emit()
	
	ready_to_attack = false
	is_attacking = false
	_timer.timeout.connect(_get_ready, CONNECT_ONE_SHOT)
	_timer.start(time_between_attacks)
