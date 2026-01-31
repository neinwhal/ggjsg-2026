extends Node2D

var scene_selection: Array[PackedScene]
var rand: RandomNumberGenerator

const SECTION_WIDTH: int = 2016
#const VIEWPORT_SIZE: int = 1152

const LEVEL_1_START : String = "res://src/level/start_section.tscn"
const LEVEL_1_END : String = "res://src/level/end_section.tscn"
const LEVEL_2_START : String = "res://src/level/base_section.tscn"
const LEVEL_2_END : String = "res://src/level/base_section.tscn"

var current_max_x: int = SECTION_WIDTH
var mid_section_count: int = 0
var is_end_generated: bool = false
var current_level: int = 1


# Called when the node enters the scene tree for the first time.d
func _ready() -> void:
	pass # Replace with function body.
	current_level = CurrentLevel.lvl
	if current_level == 1:
		scene_selection.append(preload("res://src/level/section_a.tscn"))
		scene_selection.append(preload("res://src/level/section_b.tscn"))
		scene_selection.append(preload("res://src/level/section_c.tscn"))
	
	## Use this if floor is to match exact wall length
	#$Floor/CollisionShape2D.shape.size.x = SECTION_WIDTH * (scene_selection.size() + 2) # +2 for start and end
	#$Floor.position.x = ($Floor/CollisionShape2D.shape.size.x / 2.0) - (SECTION_WIDTH / 2.0)
	
	## Use this if floor is to extend by 1 SECTION_WIDTH past the wall sprite of both ends
	$Floor/CollisionShape2D.shape.size.x = SECTION_WIDTH * (scene_selection.size() + 4)
	$Floor.position.x = ($Floor/CollisionShape2D.shape.size.x / 2.0) - (SECTION_WIDTH * 1.5)
	
	rand = RandomNumberGenerator.new()
	rand.randomize()
	
	generate_start_section()
	generate_random_section(SECTION_WIDTH)
	$RightExtent.position.x = SECTION_WIDTH
	print_debug("Current level is: ", current_level)
	
	$CanvasLayer/BranchingMrtMap._on_lvl_2_button_pressed.connect(go_next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		pause()

func generate_start_section() -> void:
	var start_scene : Node2D
	if current_level == 1:
		start_scene = preload(LEVEL_1_START).instantiate()
	elif current_level == 2:
		start_scene = preload(LEVEL_2_START).instantiate()
	start_scene.position.x = 0
	$SpawnedSections.call_deferred("add_child", start_scene)

func generate_end_section(xpos: int) -> void:
	if is_end_generated:
		return
	is_end_generated = true
	var end_scene : Node2D
	if current_level == 1:
		end_scene = preload(LEVEL_1_END).instantiate()
	elif current_level == 2:
		end_scene = preload(LEVEL_2_END).instantiate()
	end_scene.position.x = xpos
	end_scene._on_final_extent_entered.connect(open_branching_mrt)
	end_scene._on_mrt_map_exited.connect(close_branching_mrt)
	$SpawnedSections.call_deferred("add_child", end_scene)

## Obtain random scene from container
func generate_random_section(xpos: int) -> void:
	if not scene_selection.is_empty():
		var new_scene := scene_selection[rand.randi_range(0, scene_selection.size() - 1)].instantiate()
		new_scene.position.x = xpos
		$SpawnedSections.call_deferred("add_child", new_scene)
		mid_section_count += 1
	else:
		print_debug("Trying to obtain scene from empty scene selection container!!!")

func open_branching_mrt() -> void:
	#print_debug("Open branching mrt")
	$CanvasLayer/BranchingMrtMap.show()

func close_branching_mrt() -> void:
	#print_debug("Close branching mrt")
	$CanvasLayer/BranchingMrtMap.hide()

func go_next_level() -> void:
	if current_level == 1:
		current_level += 1
		CurrentLevel.lvl = current_level
		get_tree().reload_current_scene()
	elif current_level == 2:
		## Go finish screen
		pass
	else:
		print_debug("Current level is invalid: ", current_level)

func pause() -> void:
	print_debug("Pause")
	get_tree().paused = true
	$CanvasLayer/PauseMenu.show()

func _on_right_extent_body_entered(body: Node2D) -> void:
	#print_debug("Hit right extent!!!")
	## Spawn section to right
	if mid_section_count == scene_selection.size():
		current_max_x += SECTION_WIDTH
		generate_end_section(current_max_x)
	else:
		current_max_x += SECTION_WIDTH
		$RightExtent.position.x += SECTION_WIDTH
		generate_random_section(current_max_x)
