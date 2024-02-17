extends Control

@onready var vegetables_amount_label: Label = %VegetablesAmountLabel
@onready var team_label: Label = %TeamLabel

func _ready() -> void:
	setup.call_deferred()

func setup() -> void:
	Globals.vegetable_count_changed.connect(_on_vegetables_changed, CONNECT_DEFERRED)
	Globals.player.item_holder.item_released.connect(func(v): _on_vegetables_changed())
	Globals.player.item_holder.item_picked.connect(func(v): _on_vegetables_changed())
	Globals.team_changed.connect(_on_team_changed)
	
	_on_team_changed()
	_on_vegetables_changed()

func _on_team_changed() -> void:
	team_label.text = str(Globals.team.size()) + '/' + str(Globals.max_team)

func _on_vegetables_changed() -> void:
	var count:= Globals.vegetable_count
	if Globals.player.item_holder.is_holding_basic_vegetable():
		count += 1
	vegetables_amount_label.text = str(count)
