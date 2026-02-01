extends Node2D

var scene_selection: Array[PackedScene]

const SECTION_WIDTH: int = 2016
#const VIEWPORT_SIZE: int = 1152

const START_SCENE : String = "res://src/level/start_section.tscn"
const END_SCENE : String = "res://src/level/end_section.tscn"

@export var GREEN_DIFFICULTY_COUNT: int = 1
@export var YELLOW_DIFFICULTY_COUNT: int = 3
@export var RED_DIFFICULTY_COUNT: int = 4

var current_max_x: int = SECTION_WIDTH
var mid_section_count: int = 1
var mid_section_max: int
var is_end_generated: bool = false
### Tracks map progresion
#var current_level: int
### Indicates current map pool (assigned by branching mrt map)
#var current_zone: String
### Indicates number of mid_section_count
#var current_colour_difficulty: String


# Called when the node enters the scene tree for the first time.d
func _ready() -> void:
	pass # Replace with function body.
	#current_level = CurrentLevel.lvl
	scene_selection.clear()
	match Progression.zone:
		"A":
			## Normal Normal
			scene_selection.append(preload("res://src/level/normal_section.tscn"))
			## Normal (Healing)
			scene_selection.append(preload("res://src/level/normal(healing).tscn"))
			## Normal (rusher + rescue)
			scene_selection.append(preload("res://src/level/normal(rusher+rescue).tscn"))
			## Big (big + rescue)
			scene_selection.append(preload("res://src/level/big(rescue).tscn"))
			## Ranged (ranger + rescue)
			scene_selection.append(preload("res://src/level/ranged(ranger+rescue).tscn"))
			## Ranged (rusher + healing)
			scene_selection.append(preload("res://src/level/ranger(rusher+healing).tscn"))
			
		"B":
			pass
			## Normal Normal
			scene_selection.append(preload("res://src/level/normal_section.tscn"))
			## Normal (Healing)
			scene_selection.append(preload("res://src/level/normal(healing).tscn"))
			## Big (tanker + rescue melee elite)
			scene_selection.append(preload("res://src/level/big(tanker+rescuemeleeelite).tscn"))
			## Big (tanker + ranger + rescue)
			scene_selection.append(preload("res://src/level/big(tanker+ranger+rescue).tscn"))
			## Mega (mega + rescue bianlian)
			## Ranged (ranged elite + rescue ranger)
			scene_selection.append(preload("res://src/level/ranged(rangeelite+rescueranger)).tscn"))
		"C":
			pass
			## Big (big + heal)
			scene_selection.append(preload("res://src/level/big(heal).tscn"))
			## Mega (rager + double recruit)
			## Mega (mega + rescue bianlian)
			## Mega Mega
		"D":
			pass
		_:
			print_debug("Invalid progression zone: ", Progression.zone, "!!!")
	match Progression.color_difficulty:
		"GREEN":
			mid_section_max = GREEN_DIFFICULTY_COUNT
		"YELLOW":
			mid_section_max = YELLOW_DIFFICULTY_COUNT
		"RED":
			mid_section_max = RED_DIFFICULTY_COUNT
		_:
			print_debug("Invalid progression color difficulty: ", Progression.color_difficulty, "!!!")
	
	## Use this if floor is to match exact wall length
	#$Floor/CollisionShape2D.shape.size.x = SECTION_WIDTH * (scene_selection.size() + 2) # +2 for start and end
	#$Floor.position.x = ($Floor/CollisionShape2D.shape.size.x / 2.0) - (SECTION_WIDTH / 2.0)
	
	## Use this if floor is to extend by 1 SECTION_WIDTH past the wall sprite of both ends
	$Floor/CollisionShape2D.shape.size.x = SECTION_WIDTH * (mid_section_count + 2 + 2) # +2 for begin/end, +2 for extra width for enemy spawn
	$Floor.position.x = ($Floor/CollisionShape2D.shape.size.x / 2.0) - (SECTION_WIDTH * 1.5)
	
	
	generate_start_section()
	generate_random_section(SECTION_WIDTH / 3.0)
	$RightExtent.position.x = SECTION_WIDTH / 3.0
	print_debug("Current node is: ", Progression.node)
	
	$CanvasLayer/BranchingMrtMap.on_mrt_node_pressed.connect(go_next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		pause()

func generate_start_section() -> void:
	var start_scene : Node2D
	## Only change if we want to have diff start sections per lvl
	start_scene = preload(START_SCENE).instantiate()
	start_scene.position.x = 0
	$SpawnedSections.call_deferred("add_child", start_scene)

func generate_end_section(xpos: int) -> void:
	if is_end_generated:
		return
	is_end_generated = true
	var end_scene : Node2D
	## Only change if we want to have diff end sections per lvl
	end_scene = preload(END_SCENE).instantiate()
	
	end_scene.position.x = xpos
	end_scene._on_final_extent_entered.connect(open_branching_mrt)
	end_scene._on_mrt_map_exited.connect(close_branching_mrt)
	$SpawnedSections.call_deferred("add_child", end_scene)

## Obtain random scene from container
func generate_random_section(xpos: int) -> void:
	if not scene_selection.is_empty():
		var new_scene := scene_selection[Progression.rand.randi_range(0, scene_selection.size() - 1)].instantiate()
		new_scene.position.x = xpos
		$SpawnedSections.call_deferred("add_child", new_scene)
		mid_section_count += 1
	else:
		print_debug("Trying to obtain scene from empty scene selection container!!!")

func open_branching_mrt() -> void:
	#print_debug("Open branching mrt")
	$CanvasLayer/BranchingMrtMap.open_branching_mrt()

func close_branching_mrt() -> void:
	#print_debug("Close branching mrt")
	$CanvasLayer/BranchingMrtMap.hide()

func go_next_level(next_lvl: int, zone: String, colour_difficulty: String) -> void:
	#current_level += 1
	Progression.node = next_lvl
	Progression.zone = zone
	Progression.color_difficulty = colour_difficulty
	get_tree().reload_current_scene()
	#if current_level == 1:
		#current_level += 1
		#CurrentLevel.lvl = current_level
		#get_tree().reload_current_scene()
	#elif current_level == 2:
		### Go finish screen
		#pass
	#else:
		#print_debug("Current level is invalid: ", current_level)

func pause() -> void:
	print_debug("Pause")
	get_tree().paused = true
	$CanvasLayer/PauseMenu.show()

func _on_right_extent_body_entered(body: Node2D) -> void:
	if not body is PlayerBasic:
		return
	#print_debug("Hit right extent!!!")
	## Spawn section to right
	if mid_section_count >= mid_section_max:
		print("spawn end")
		current_max_x #+= SECTION_WIDTH / 3.0
		generate_end_section(current_max_x)
	else:
		print("spawn mid")
		current_max_x += SECTION_WIDTH
		$RightExtent.position.x += SECTION_WIDTH
		generate_random_section(current_max_x)
