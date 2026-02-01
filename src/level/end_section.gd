extends Node2D

signal _on_final_extent_entered()
signal _on_mrt_map_exited()

func _on_final_extent_body_entered(body: Node2D) -> void:
	if body is PlayerBasic:
		_on_final_extent_entered.emit()


func _on_exit_mrt_map_body_exited(body: Node2D) -> void:
	_on_mrt_map_exited.emit()
