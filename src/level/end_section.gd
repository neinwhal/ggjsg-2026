extends Node2D

signal _on_final_extent_entered()

func _on_final_extent_body_entered(body: Node2D) -> void:
	_on_final_extent_entered.emit()
