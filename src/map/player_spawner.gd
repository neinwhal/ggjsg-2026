extends Node2D

@onready var PlayerScene: PackedScene = preload("res://src/player/player_basic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var e := PlayerScene.instantiate()
	e.global_position = Vector2(600, 300)
	add_child(e)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
