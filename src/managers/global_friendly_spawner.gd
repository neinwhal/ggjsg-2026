extends Node2D

@onready var FriendlyScene: PackedScene = preload("res://src/friendly/friendly_basic.tscn")

@onready var FriendlyTank: PackedScene = preload("res://src/friendly/friendly_tank.tscn")
@onready var FriendlyMelee: PackedScene = preload("res://src/friendly/friendly_melee.tscn")
@onready var FriendlyMelee2: PackedScene = preload("res://src/friendly/friendly_melee_2.tscn")
@onready var FriendlyBianlian: PackedScene = preload("res://src/friendly/friendly_bianlian.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var spawn_timer := 0.0
var spawn_count : int = 0
var max_count : int = 1

func spawn_friendly() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	spawn_count = spawn_count + 1
	var e := FriendlyTank.instantiate()
	var e2 := FriendlyMelee.instantiate()
	var e3 := FriendlyMelee2.instantiate()
	var e4 := FriendlyBianlian.instantiate()
	e.global_position = Vector2(player.global_position.x + randf_range(-250.0, 250.0), -500.0)
	e2.global_position = Vector2(player.global_position.x + randf_range(-250.0, 250.0), -500.0)
	e3.global_position = Vector2(player.global_position.x + randf_range(-250.0, 250.0), -500.0)
	e4.global_position = Vector2(player.global_position.x + randf_range(-250.0, 250.0), -500.0)
	add_child(e)
	add_child(e2)
	add_child(e3)
	add_child(e4)


var temp_spawning_stop : bool = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (spawn_count < max_count):
		spawn_timer += delta
		
		if spawn_timer >= 1.0:
			spawn_timer = 0.0
			spawn_friendly()
		
	#### CHEAT SPAWNS
	if Input.is_key_pressed(KEY_X):
		if (!temp_spawning_stop):
			temp_spawning_stop = true
			spawn_friendly()
	else:
		if (temp_spawning_stop):
			temp_spawning_stop = false
		
