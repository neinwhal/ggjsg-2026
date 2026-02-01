extends Node2D

@onready var EnemyShambler: PackedScene = preload("res://src/enemy/enemy_shambler.tscn")
@onready var EnemyRusher: PackedScene = preload("res://src/enemy/enemy_rusher.tscn")
@onready var EnemyRager: PackedScene = preload("res://src/enemy/enemy_rager.tscn")
@onready var EnemyDodger: PackedScene = preload("res://src/enemy/enemy_dodger.tscn")
@onready var EnemyRanger: PackedScene = preload("res://src/enemy/enemy_ranged.tscn")
@onready var EnemyRanger2: PackedScene = preload("res://src/enemy/enemy_ranged_2.tscn")
@onready var EnemyRat: PackedScene = preload("res://src/enemy/enemy_rat.tscn")
@onready var EnemyTanker: PackedScene = preload("res://src/enemy/enemy_tanker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var spawn_timer := 0.0

func spawn_enemy() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return

	# randomize spawning creatures
	var roll := 3 #randi_range(1, 8)
	var enemy_scene: PackedScene
	if roll == 1:
		enemy_scene = EnemyShambler
	elif roll == 2:
		enemy_scene = EnemyRusher
	elif roll == 3:
		enemy_scene = EnemyRager
	elif roll == 4:
		enemy_scene = EnemyDodger
	elif roll == 5:
		enemy_scene = EnemyRanger
	elif roll == 6:
		enemy_scene = EnemyRanger2
	elif roll == 7:
		enemy_scene = EnemyRat
	elif roll == 8:
		enemy_scene = EnemyTanker
		
	# actually psawn
	var e := enemy_scene.instantiate()
	add_child(e)
	# randomize side to spawn
	var player_pos: Vector2 = player.global_position
	var side : float = [-1.0, 1.0].pick_random()
	# X relative to player, Y fixed
	e.global_position = Vector2(
		player_pos.x + 1000.0 * side,
		-500.0
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta

	if spawn_timer >= 1.0:
		spawn_timer = 0.0
		spawn_enemy()
