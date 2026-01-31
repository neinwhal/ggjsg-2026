extends Control

signal _on_unpaused_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()

func _on_return_pressed() -> void:
	hide()
	_on_unpaused_pressed.emit()
	
func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/ui/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
