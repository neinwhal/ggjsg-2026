extends Node2D

@onready var EnemyScene: PackedScene = preload("res://src/enemy/enemy_basic.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var spawn_timer := 0.0

func spawn_enemy() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var e := EnemyScene.instantiate()
	add_child(e)
	
	var player_pos: Vector2 = player.global_position
	var side : float = [-1.0, 1.0].pick_random()

	# X relative to player, Y fixed
	e.global_position = Vector2(
		player_pos.x + 1000.0 * side,
		300.0
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta

	if spawn_timer >= 1.0:
		spawn_timer = 0.0
		spawn_enemy()
