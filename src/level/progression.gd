extends Node

var node: int
var zone: String # to decide spawn pools
var color_difficulty: String

var enter_from_main_menu: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_progression()

func reset_progression() -> void:
	## Initial lvl
	node = 11
	zone = "A"
	color_difficulty = "GREEN"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
