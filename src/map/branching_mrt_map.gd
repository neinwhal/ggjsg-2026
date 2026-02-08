extends Control

#signal _on_lvl_2_button_pressed()

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
	## Logic to determine what node to allow selection
	for n in $Nodes.get_children():
		var node: TextureButton = n as TextureButton
		node.set_unlighted()
		#print_debug("sfeneffef")
		#node.set_unlighted()
	match Progression.node:
		0:
			$"Nodes/Node(1,1)".set_blinking()
		11:
			$"Nodes/Node(2,1)".set_blinking()
			$"Nodes/Node(2,2)".set_blinking()
		21:
			$"Nodes/Node(3,1)".set_blinking()
			$"Nodes/Node(3,2)".set_blinking()
		22:
			$"Nodes/Node(3,2)".set_blinking()
			$"Nodes/Node(3,3)".set_blinking()
		31:
			$"Nodes/Node(4,1)".set_blinking()
		32:
			$"Nodes/Node(4,1)".set_blinking()
			$"Nodes/Node(4,2)".set_blinking()
		33:
			$"Nodes/Node(4,2)".set_blinking()
		41:
			$"Nodes/Node(5,1)".set_blinking()
			$"Nodes/Node(5,2)".set_blinking()
		42:
			$"Nodes/Node(5,2)".set_blinking()
			$"Nodes/Node(5,3)".set_blinking()
		51:
			$"Nodes/Node(6,1)".set_blinking()
		52:
			$"Nodes/Node(6,1)".set_blinking()
			$"Nodes/Node(6,2)".set_blinking()
		53:
			$"Nodes/Node(6,2)".set_blinking()
		61:
			$"Nodes/Node(7,1)".set_blinking()
		62:
			$"Nodes/Node(7,1)".set_blinking()
		71:
			print_debug("Shouldn't be accessing map at the end of 71(final node)!!!")
		_:
			print_debug("Invalid progression node: ", Progression.node, "!!!")
	show()

func close_branching_mrt() -> void:
	hide()

func _on_node_11_pressed() -> void:
	## Zone A, green
	hide()
	Progression.set_level_one("A", "GREEN")
	get_tree().change_scene_to_file("res://src/level/main_level.tscn")


func _on_node_21_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(21, "A", "GREEN")


func _on_node_22_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(22, "A", "GREEN")


func _on_node_31_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(31, "B", "GREEN")


func _on_node_32_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(32, "B", "GREEN")


func _on_node_33_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(33, "B", "GREEN")


func _on_node_41_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(41, "B", "GREEN")


func _on_node_42_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(42, "B", "GREEN")


func _on_node_51_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(51, "C", "GREEN")


func _on_node_52_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(52, "C", "GREEN")


func _on_node_53_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(53, "C", "GREEN")


func _on_node_61_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(61, "C", "GREEN")


func _on_node_62_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(62, "C", "GREEN")


func _on_node_71_pressed() -> void:
	hide()
	on_mrt_node_pressed.emit(71, "D", "GREEN")
