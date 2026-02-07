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
			print_debug("setting nfiefbe")
			$"Nodes/Node(1,1)".set_blinking()
		11:
			pass
		21:
			pass
		22:
			pass
		31:
			pass
		32:
			pass
		33:
			pass
		41:
			pass
		42:
			pass
		51:
			pass
		52:
			pass
		53:
			pass
		61:
			pass
		62:
			pass
		71:
			pass
		_:
			pass
	show()

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
