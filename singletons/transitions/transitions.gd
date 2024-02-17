extends CanvasLayer

const BLACK_FADE:= "black_fade"

var is_transitioning: bool

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func start_transition(trans_name: String, speed: float, on_finished: Callable):
	is_transitioning = true
	get_tree().paused = true
	get_tree().root.set_process_input(false)
	animation_player.play(trans_name + "_start", -1, speed)
	await animation_player.animation_finished
	if on_finished:
		on_finished.call()

func end_transition(trans_name: String, speed: float, on_finished: Callable):
	animation_player.play(trans_name + "_end", -1, speed)
	await animation_player.animation_finished
	get_tree().root.set_process_input(true)
	get_tree().paused = false
	is_transitioning = false
	if on_finished:
		on_finished.call()
