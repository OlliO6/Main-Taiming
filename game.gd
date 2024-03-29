class_name Game
extends Node2D

signal fight_started
signal fight_ended
signal about_to_fight

@onready var camera: PhantomCamera2D = $Camera
@onready var room_holder: Node2D = $RoomHolder
@onready var player: Player = $Player

@export var rooms: Array[PackedScene]
@export var start_vegis: int = 5

enum GameState { FIGHT, PREPERATION, PAUSED, NOT_IN_GAME, ABOUT_TO_FIGHT }
static  var game_state: GameState = GameState.NOT_IN_GAME

var current_room: int

func _ready() -> void:
	
	Globals.vegetable_count = start_vegis
	
	Transitions.end_transition.call_deferred(Transitions.BLACK_FADE, 0.5, func():)
	
	game_state = GameState.PREPERATION
	
	enter_room()
	Globals.team_changed.connect(_on_team_changed)

func _exit_tree() -> void:
	game_state = GameState.NOT_IN_GAME

static func in_game() -> bool:
	return game_state != GameState.NOT_IN_GAME

func about_to_start_fight() -> void:
	game_state = GameState.ABOUT_TO_FIGHT
	about_to_fight.emit()

func start_fight():
	game_state = GameState.FIGHT
	fight_started.emit()

func end_fight():
	game_state = GameState.PREPERATION
	fight_ended.emit()
	
func enter_room() -> void:
	
	if current_room >= rooms.size():
		print("no more rooms")
		return
	
	var room_scene:= rooms[current_room] as PackedScene
	var room:= room_scene.instantiate() as Node2D
	
	for m in Globals.team:
		m.get_parent().remove_child(m)
	player.get_parent().remove_child(player)
	
	if room_holder.get_child_count() > 0:
		var prev_room = room_holder.get_child(0)
		room_holder.remove_child(prev_room)
		prev_room.queue_free()
	
	room_holder.add_child(room)
	player.position = room.get_node("SpawnPositions/Player").position
	room.add_child(player)
	camera.set_limit_node(room)
	camera.update_limit_all_sides()
	room.get_node("Door").player_entered.connect(_on_room_exited)
	_add_team_to_room(room)

func _unparent_team() -> void:
	for m in Globals.team:
		m.get_parent().remove_child(m)

func _add_team_to_room(room: Node2D) -> void:
	var spawn_points:= room.get_node("SpawnPositions/Team")
	
	for i in Globals.team.size():
		
		var spawn_pos: Vector2
		if spawn_points.get_child_count() > i:
			spawn_pos = spawn_points.get_child(i).global_position
		else:
			spawn_pos = Vector2.ZERO
		
		var monster = Globals.team[i]
		monster.position = spawn_pos
		room.add_child(monster)
		monster.velocity = Vector2.ZERO

func _on_room_exited() -> void:
	Transitions.start_transition(Transitions.BLACK_FADE, 1, func():
		current_room += 1
		enter_room()
		Transitions.end_transition(Transitions.BLACK_FADE, 1, func(): return))

func _on_team_changed() -> void:
	if Globals.team.size() == 0 && game_state == GameState.FIGHT:
		process_mode = Node.PROCESS_MODE_DISABLED
		var tween:= $Music.create_tween()
		tween.tween_property($CanvasLayer/GameOver, "modulate:a", 1.0, 10).set_trans(Tween.TRANS_CUBIC)
		tween.tween_interval(5)
		tween.tween_callback(func():
			Transitions.start_transition(Transitions.BLACK_FADE, 1, func():
				get_tree().reload_current_scene()))

func enter_last_door() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	var tween:= $Music.create_tween()
	tween.tween_property($CanvasLayer/GameOver, "modulate:a", 1.0, 10).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(5)
	tween.tween_callback(func():
		Transitions.start_transition(Transitions.BLACK_FADE, 1, func():
			get_tree().reload_current_scene()))
