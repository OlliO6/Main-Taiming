extends CharacterBody2D

signal player_entered

var is_open: bool

var _explanation_tween: Tween

func open() -> void:
	is_open = true
	$DoorCollider.disabled = true
	$Sprite2D.frame = 1
	$EnterArea/CollisionShape2D.disabled = false

func _ready() -> void:
	$Interactable.allow_interaction = allow_interaction

func allow_interaction() -> bool:
	return !is_open && Game.game_state != Game.GameState.FIGHT

func _on_interacted() -> void:
	
	if Game.game_state == Game.GameState.ABOUT_TO_FIGHT:
		
		return
	
	if Globals.team.size() < 1:
		var explanation:= $TeamExplanation as Label
		explanation.show()
		if is_instance_valid(_explanation_tween) && _explanation_tween.is_valid():
			_explanation_tween.kill()
		_explanation_tween = create_tween()
		_explanation_tween.tween_property(explanation, "modulate:a", 0.0, 3).from(1.0)\
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		_explanation_tween.tween_callback(explanation.hide)
		return
	open()

func _on_enter_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()
