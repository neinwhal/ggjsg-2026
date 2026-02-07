extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()

func _on_return_pressed() -> void:
	hide()
	get_tree().paused = false
	
func _on_back_to_main_menu_pressed() -> void:
	get_tree().paused = false
	Progression.reset_progression()
	get_tree().change_scene_to_file("res://src/ui/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
