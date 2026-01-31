extends Node2D

@onready var FriendlyScene: PackedScene = preload("res://src/friendly/friendly_basic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var spawn_timer := 0.0
var spawn_count : int = 0
var max_count : int = 1

func spawn_friendly() -> void:
	spawn_count = spawn_count + 1
	if (spawn_count <= max_count):
		var e := FriendlyScene.instantiate()
		e.global_position = Vector2(600, 300)
		add_child(e)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta

	if spawn_timer >= 1.0:
		spawn_timer = 0.0
		spawn_friendly()
