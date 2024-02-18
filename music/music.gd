extends Node

@export var play_drums_at_room: int

@onready var melody: AudioStreamPlayer = $Melody
@onready var drums: AudioStreamPlayer = $Drums

var drum_tween: Tween

func _ready() -> void:
	drums.volume_db = linear_to_db(0)

func _on_game_about_to_fight() -> void:
	
	if Globals.get_game().current_room <= play_drums_at_room:
		return
	
	if is_instance_valid(drum_tween) && drum_tween.is_valid():
		drum_tween.kill()
	
	drum_tween = create_tween()
	drum_tween.tween_method(func(v): drums.volume_db = linear_to_db(v) , 0.0, 1.0, 10)\
		.set_trans(Tween.TRANS_CUBIC)

func _on_game_fight_ended() -> void:
	
	if Globals.get_game().current_room <= play_drums_at_room:
		return
	
	if is_instance_valid(drum_tween) && drum_tween.is_valid():
		drum_tween.kill()
	
	drum_tween = create_tween()
	drum_tween.tween_method(func(v): drums.volume_db = linear_to_db(v) , 1.0, 0.0, 10)\
		.set_trans(Tween.TRANS_CUBIC)
