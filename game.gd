class_name Game
extends Node2D

const room_list_path:= "res://rooms/list/"

@onready var camera: PhantomCamera2D = $Camera
@onready var room_holder: Node2D = $RoomHolder
@onready var player: Player = $Player

var current_room: int

var _room_files: PackedStringArray

func _ready() -> void:
	var rooms_dir:= DirAccess.open(room_list_path)
	_room_files = rooms_dir.get_files()
	enter_room()

func enter_room() -> void:
	
	if current_room >= _room_files.size():
		print("no more rooms")
		return
	
	var room_scene:= load(room_list_path + _room_files[current_room]) as PackedScene
	var room:= room_scene.instantiate() as Node2D
	
	if room_holder.get_child_count() > 0:
		var prev_room = room_holder.get_child(0)
		room_holder.remove_child(prev_room)
		prev_room.queue_free()
	
	
	player.position = room.get_node("PlayerSpawn").position
	room_holder.add_child(room)
	camera.set_limit_node(room)
	camera.update_limit_all_sides()
	room.get_node("Door").player_entered.connect(_on_room_exited)

func _on_room_exited() -> void:
	Transitions.start_transition(Transitions.BLACK_FADE, 1, func():
		current_room += 1
		enter_room()
		Transitions.end_transition(Transitions.BLACK_FADE, 1, func(): return))
