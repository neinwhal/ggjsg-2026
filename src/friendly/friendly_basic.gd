extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var speed : float = 80.0
var direction : float = 0.0
var change_time : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_time -= delta

	if change_time <= 0.0:
		direction = [-1, 1].pick_random()
		change_time = randf_range(0.5, 1.5)

	position.x += direction * speed * delta
