extends Node

var node: int
var zone: String # to decide spawn pools
var color_difficulty: String

var enter_from_main_menu: bool = false
var rand: RandomNumberGenerator

var color_diff_saved: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rand = RandomNumberGenerator.new()
	rand.randomize()
	reset_progression()

func reset_progression() -> void:
	node = 0
	
	color_diff_saved.clear()
	for i in 14:
		var random_int: int = rand.randi_range(0, 2)
		match random_int:
			0:
				color_diff_saved.append("GREEN")
			1:
				color_diff_saved.append("YELLOW")
			2:
				color_diff_saved.append("RED")

func set_level_one(_zone: String = "A", _color: String = "GREEN") -> void:
	node = 11
	zone = _zone
	color_difficulty = _color
