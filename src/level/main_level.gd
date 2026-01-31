extends Node2D

var scene_selection: Array[PackedScene]
var rand: RandomNumberGenerator

#const SECTION_WIDTH: int = 2304 #x2 viewport x
const SECTION_WIDTH: int = 1728 # x1.5 viewport x
const VIEWPORT_SIZE: int = 1152
var current_min_x: int = -SECTION_WIDTH
var current_max_x: int = SECTION_WIDTH


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	scene_selection.append(preload("res://src/level/section_a.tscn"))
	scene_selection.append(preload("res://src/level/section_b.tscn"))
	scene_selection.append(preload("res://src/level/section_c.tscn"))
	
	rand = RandomNumberGenerator.new()
	rand.randomize()
	
	generate_random_section(0)
	generate_random_section(-SECTION_WIDTH)
	generate_random_section(SECTION_WIDTH)
	#update_section_around_player()
	$LeftExtent.position.x = -SECTION_WIDTH
	$RightExtent.position.x = SECTION_WIDTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_section_around_player() -> void:
	## Triggered when player hits world extent
	if $PlayerBasic.position.x < 0:
		## Spawn section to left
		current_min_x -= SECTION_WIDTH
		$LeftExtent.position.x -= SECTION_WIDTH
		generate_random_section(current_min_x)
		#print_debug("Spawning left")
	elif $PlayerBasic.position.x > 0:
		## Spawn section to right
		current_max_x += SECTION_WIDTH
		$RightExtent.position.x += SECTION_WIDTH
		generate_random_section(current_max_x)
		#print_debug("Spawning right")
	else:
		## Shouldnt happen
		print_debug("Player xpos is 0 when hitting world boundary!!!")
		pass

## Obtain random scene from container
func generate_random_section(xpos: int) -> void:
	if not scene_selection.is_empty():
		var new_scene := scene_selection[rand.randi_range(0, scene_selection.size() - 1)].instantiate()
		new_scene.position.x = xpos
		#add_child(new_scene)
		call_deferred("add_child", new_scene)
	else:
		print_debug("Trying to obtain scene from empty scene selection container!!!")


func _on_left_extent_body_entered(body: Node2D) -> void:
	print_debug("Hit left extent!!!")
	update_section_around_player()


func _on_right_extent_body_entered(body: Node2D) -> void:
	print_debug("Hit right extent!!!")
	update_section_around_player()
