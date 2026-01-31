extends Node2D

var scene_selection: Array[PackedScene]
var rand: RandomNumberGenerator

#const SECTION_WIDTH: int = 2304 #x2 viewport x
const SECTION_WIDTH: int = 2016
#const VIEWPORT_SIZE: int = 1152
const MAX_MID_SECTIONS: int = 3
var current_max_x: int = SECTION_WIDTH
var mid_section_count: int = 0
var is_end_generated: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	scene_selection.append(preload("res://src/level/section_a.tscn"))
	scene_selection.append(preload("res://src/level/section_b.tscn"))
	scene_selection.append(preload("res://src/level/section_c.tscn"))
	
	rand = RandomNumberGenerator.new()
	rand.randomize()
	
	generate_start_section()
	generate_random_section(SECTION_WIDTH)
	#update_section_around_player()
	$RightExtent.position.x = SECTION_WIDTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func generate_start_section(xpos: int = 0) -> void:
	var start_scene := preload("res://src/level/start_section.tscn").instantiate()
	start_scene.position.x = 0
	call_deferred("add_child", start_scene)

func generate_end_section(xpos: int) -> void:
	if is_end_generated:
		return
	is_end_generated = true
	var end_scene := preload("res://src/level/end_section.tscn").instantiate()
	end_scene.position.x = xpos
	end_scene._on_final_extent_entered.connect(open_branching_mrt)
	call_deferred("add_child", end_scene)

## Obtain random scene from container
func generate_random_section(xpos: int) -> void:
	if not scene_selection.is_empty():
		var new_scene := scene_selection[rand.randi_range(0, scene_selection.size() - 1)].instantiate()
		new_scene.position.x = xpos
		#add_child(new_scene)
		call_deferred("add_child", new_scene)
		mid_section_count += 1
	else:
		print_debug("Trying to obtain scene from empty scene selection container!!!")

func open_branching_mrt() -> void:
	print_debug("Open branching mrt")

func _on_right_extent_body_entered(body: Node2D) -> void:
	#print_debug("Hit right extent!!!")
	## Spawn section to right
	if mid_section_count == MAX_MID_SECTIONS:
		current_max_x += SECTION_WIDTH
		generate_end_section(current_max_x)
	else:
		current_max_x += SECTION_WIDTH
		$RightExtent.position.x += SECTION_WIDTH
		generate_random_section(current_max_x)
