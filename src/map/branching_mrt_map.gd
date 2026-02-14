extends Control

var green_texture:= preload("res://assets/map/GREEN_NODE_FLASHING.png")
var yellow_texture:= preload("res://assets/map/YELLOW_NODE_FLASHING.png")
var red_texture:= preload("res://assets/map/RED_NODE_FLASHING.png")

## Map logic
## Zone A - col 1-2
## Zone B - col 3-4
## Zone C - col 5-6
## Zone D - col 7
signal on_mrt_node_pressed(next_node: int, zone: String, colour_difficulty: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Progression.enter_from_main_menu:
		Progression.enter_from_main_menu = false
		open_branching_mrt()
	else:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func open_branching_mrt() -> void:
	## Popup animation (start from 1 window size above)
	var tween = get_tree().create_tween()
	position = Vector2(0, -get_window().size.y)
	tween.tween_property(self, "position", Vector2(0, 0), 0.5).set_trans(Tween.TRANS_SINE)
	
	## Logic to determine what node to allow selection
	var idx: int = 0
	for n in $Nodes.get_children():
		var node: TextureButton = n as TextureButton
		node.set_unlighted()
		
		var atlas_normal: AtlasTexture = node.texture_normal
		match Progression.color_diff_saved[idx]:
			"GREEN":
				node.color_diff = "GREEN"
				atlas_normal.atlas = green_texture
			"YELLOW":
				node.color_diff = "YELLOW"
				atlas_normal.atlas = yellow_texture
			"RED":
				node.color_diff = "RED"
				atlas_normal.atlas = red_texture
		idx += 1
		#print_debug("sfeneffef")
		#node.set_unlighted()
	match Progression.node:
		0:
			$"Nodes/Node(1,1)".set_blinking()
		11:
			$"Nodes/Node(2,1)".set_blinking()
			$"Nodes/Node(2,2)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
		21:
			$"Nodes/Node(3,1)".set_blinking()
			$"Nodes/Node(3,2)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
		22:
			$"Nodes/Node(3,2)".set_blinking()
			$"Nodes/Node(3,3)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
		31:
			$"Nodes/Node(4,1)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
			$"Nodes/Node(4,2)".set_grayed()
			$"Nodes/Node(5,3)".set_grayed()
		32:
			$"Nodes/Node(4,1)".set_blinking()
			$"Nodes/Node(4,2)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
		33:
			$"Nodes/Node(4,2)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
			$"Nodes/Node(4,1)".set_grayed()
			$"Nodes/Node(5,1)".set_grayed()
		41:
			$"Nodes/Node(5,1)".set_blinking()
			$"Nodes/Node(5,2)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
			$"Nodes/Node(4,1)".set_grayed()
			$"Nodes/Node(4,2)".set_grayed()
			$"Nodes/Node(5,3)".set_grayed()
		42:
			$"Nodes/Node(5,2)".set_blinking()
			$"Nodes/Node(5,3)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
			$"Nodes/Node(4,1)".set_grayed()
			$"Nodes/Node(4,2)".set_grayed()
			$"Nodes/Node(5,1)".set_grayed()
		51:
			$"Nodes/Node(6,1)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
			$"Nodes/Node(4,1)".set_grayed()
			$"Nodes/Node(4,2)".set_grayed()
			$"Nodes/Node(5,1)".set_grayed()
			$"Nodes/Node(5,2)".set_grayed()
			$"Nodes/Node(5,3)".set_grayed()
			$"Nodes/Node(6,2)".set_grayed()
		52:
			$"Nodes/Node(6,1)".set_blinking()
			$"Nodes/Node(6,2)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
			$"Nodes/Node(4,1)".set_grayed()
			$"Nodes/Node(4,2)".set_grayed()
			$"Nodes/Node(5,1)".set_grayed()
			$"Nodes/Node(5,2)".set_grayed()
			$"Nodes/Node(5,3)".set_grayed()
		53:
			$"Nodes/Node(6,2)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
			$"Nodes/Node(4,1)".set_grayed()
			$"Nodes/Node(4,2)".set_grayed()
			$"Nodes/Node(5,1)".set_grayed()
			$"Nodes/Node(5,2)".set_grayed()
			$"Nodes/Node(5,3)".set_grayed()
			$"Nodes/Node(6,1)".set_grayed()
		61:
			$"Nodes/Node(7,1)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
			$"Nodes/Node(4,1)".set_grayed()
			$"Nodes/Node(4,2)".set_grayed()
			$"Nodes/Node(5,1)".set_grayed()
			$"Nodes/Node(5,2)".set_grayed()
			$"Nodes/Node(5,3)".set_grayed()
			$"Nodes/Node(6,1)".set_grayed()
			$"Nodes/Node(6,2)".set_grayed()
		62:
			$"Nodes/Node(7,1)".set_blinking()
			$"Nodes/Node(1,1)".set_grayed()
			$"Nodes/Node(2,1)".set_grayed()
			$"Nodes/Node(2,2)".set_grayed()
			$"Nodes/Node(3,1)".set_grayed()
			$"Nodes/Node(3,2)".set_grayed()
			$"Nodes/Node(3,3)".set_grayed()
			$"Nodes/Node(4,1)".set_grayed()
			$"Nodes/Node(4,2)".set_grayed()
			$"Nodes/Node(5,1)".set_grayed()
			$"Nodes/Node(5,2)".set_grayed()
			$"Nodes/Node(5,3)".set_grayed()
			$"Nodes/Node(6,1)".set_grayed()
			$"Nodes/Node(6,2)".set_grayed()
		71:
			print_debug("Shouldn't be accessing map at the end of 71(final node)!!!")
			get_tree().change_scene_to_file("res://src/ui/win_screen.tscn")
		_:
			print_debug("Invalid progression node: ", Progression.node, "!!!")
	show()

func close_branching_mrt() -> void:
	hide()

func _on_node_11_pressed() -> void:
	## Zone A, green
	hide()
	Progression.set_level_one("A", $"Nodes/Node(1,1)".color_diff)
	get_tree().change_scene_to_file("res://src/level/main_level.tscn")


func _on_node_21_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(21, "A", $"Nodes/Node(2,1)".color_diff)


func _on_node_22_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(22, "A", $"Nodes/Node(2,2)".color_diff)


func _on_node_31_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(31, "B", $"Nodes/Node(3,1)".color_diff)


func _on_node_32_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(32, "B", $"Nodes/Node(3,2)".color_diff)


func _on_node_33_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(33, "B", $"Nodes/Node(3,3)".color_diff)


func _on_node_41_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(41, "B", $"Nodes/Node(4,1)".color_diff)


func _on_node_42_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(42, "B", $"Nodes/Node(4,2)".color_diff)


func _on_node_51_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(51, "C", $"Nodes/Node(5,1)".color_diff)


func _on_node_52_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(52, "C", $"Nodes/Node(5,2)".color_diff)


func _on_node_53_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(53, "C", $"Nodes/Node(5,3)".color_diff)


func _on_node_61_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(61, "C", $"Nodes/Node(6,1)".color_diff)


func _on_node_62_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(62, "C", $"Nodes/Node(6,2)".color_diff)


func _on_node_71_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(71, "D", $"Nodes/Node(7,1)".color_diff)
