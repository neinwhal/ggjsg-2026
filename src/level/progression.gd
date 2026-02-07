extends Node

var node: int
var zone: String # to decide spawn pools
var color_difficulty: String

var enter_from_main_menu: bool = false
var rand: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rand = RandomNumberGenerator.new()
	rand.randomize()
	reset_progression()

func reset_progression() -> void:
	node = 0

func set_level_one(_zone: String = "A", _color: String = "GREEN") -> void:
	node = 11
	zone = _zone
	color_difficulty = _color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
