extends Node2D

@onready var EnemyScene: PackedScene = preload("res://src/enemy/enemy_basic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var spawn_timer := 0.0

func spawn_enemy() -> void:
	var e := EnemyScene.instantiate()
	e.global_position = Vector2(600, 300)
	add_child(e)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta

	if spawn_timer >= 1.0:
		spawn_timer = 0.0
		spawn_enemy()
