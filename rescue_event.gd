extends Node2D

var possible_npcs: Array[String] = [
	"ALLYTANK",
	"RANGED",
	"ELITERANGED",
	"ELITEMELEE",
	"MELEE"
]
var file_path: String = "res://assets/level/%s_RESCUE.png"
var selected_npc: String
const DESIRED_FPS: int = 5
var duration_per_frame: float = 1.0 / DESIRED_FPS
var duration_counter: float

## Rescue mechanics
const required_rescue_time: float = 3.0
var current_progress: float = 0.0
var in_rescue_range: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug("rescue _ready")
	var random_number: int = Progression.rand.randi_range(0, 4)
	selected_npc = possible_npcs[random_number]
	$Sprite2D.texture = load(file_path % selected_npc)
	## Need to set to custom scale depending on npc
	match selected_npc:
		"ALLYTANK":
			$Sprite2D.scale = Vector2(2.5,2.5)
		"RANGED":
			$Sprite2D.scale = Vector2(2,2)
		"ELITERANGED":
			$Sprite2D.scale = Vector2(2,2)
		"ELITEMELEE":
			$Sprite2D.scale = Vector2(2,2)
		"MELEE":
			$Sprite2D.scale = Vector2(2,2)
	$Sprite2D.hframes = 4
	$Sprite2D.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print_debug(current_progress)
	duration_counter += delta
	if duration_counter >= duration_per_frame:
		duration_counter -= duration_per_frame
		## Change frame
		if ($Sprite2D.frame + 1) == $Sprite2D.hframes:
			$Sprite2D.frame = 0
		else:
			$Sprite2D.frame += 1
	
	if in_rescue_range and Input.is_action_pressed("Rescue"):
		current_progress += delta
		if current_progress >= required_rescue_time:
			## Spawn relevant stuff here
			var npc_to_spawn: CharacterBody2D
			match selected_npc:
				"ALLYTANK":
					npc_to_spawn = load("res://src/friendly/friendly_tank.tscn").instantiate()
				"RANGED":
					npc_to_spawn = load("res://src/friendly/friendly_ranged.tscn").instantiate()
				"ELITERANGED":
					npc_to_spawn = load("res://src/friendly/friendly_ranged_2.tscn").instantiate()
				"MELEE":
					npc_to_spawn = load("res://src/friendly/friendly_melee.tscn").instantiate()
				"ELITEMELEE":
					npc_to_spawn = load("res://src/friendly/friendly_melee_2.tscn").instantiate()
			npc_to_spawn.position = global_position
			## Spawn under global spawner if possible
			## Spawn directly under root if spawner don't exist
			## Only affects layering
			var parent_node_for_spawned_npc:= get_tree().root.get_node_or_null("MainLevel/GlobalFriendlySpawner")
			if parent_node_for_spawned_npc:
				parent_node_for_spawned_npc.add_child(npc_to_spawn)
			else:
				get_tree().root.add_child(npc_to_spawn)
			queue_free()
	else:
		current_progress = 0.0


func _on_rescue_area_body_entered(body: Node2D) -> void:
	if body is PlayerBasic:
		in_rescue_range = true


func _on_rescue_area_body_exited(body: Node2D) -> void:
	if body is PlayerBasic:
		in_rescue_range = false
