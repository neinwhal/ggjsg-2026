extends Node2D

@onready var FriendlyTank: PackedScene = preload("res://src/friendly/friendly_tank.tscn")
@onready var FriendlyMelee: PackedScene = preload("res://src/friendly/friendly_melee.tscn")
@onready var FriendlyMelee2: PackedScene = preload("res://src/friendly/friendly_melee_2.tscn")
@onready var FriendlyBianlian: PackedScene = preload("res://src/friendly/friendly_bianlian.tscn")

@onready var FriendlyRanged: PackedScene = preload("res://src/friendly/friendly_ranged.tscn")
@onready var FriendlyRanged2: PackedScene = preload("res://src/friendly/friendly_ranged_2.tscn")

@onready var friendly_key_map := {
	KEY_1: FriendlyMelee,
	KEY_2: FriendlyMelee2,
	KEY_3: FriendlyRanged,
	KEY_4: FriendlyRanged2,
	KEY_5: FriendlyTank,
	KEY_6: FriendlyBianlian,
	KEY_7: FriendlyRanged2,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var spawn_timer := 0.0
var spawn_count : int = 0
var max_count : int = 1

func spawn_friendly(friendly_scene: PackedScene) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return

	spawn_count += 1

	var e := friendly_scene.instantiate() as Node2D
	add_child(e)

	e.global_position = Vector2(
		player.global_position.x + randf_range(-250.0, 250.0),
		-500.0
	)

var temp_spawning_stop : bool = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for key in friendly_key_map.keys():
		if Input.is_key_pressed(key):
			if not temp_spawning_stop:
				temp_spawning_stop = true
				spawn_friendly(friendly_key_map[key])
			return
	# reset latch when no key is held
	temp_spawning_stop = false
