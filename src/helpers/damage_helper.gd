extends Object
class_name DamageHelper

static func flash_red(
	sprite: CanvasItem,
	tree: SceneTree,
	_is_flashing: bool,
	_flash_duration: float
	) -> void:
	if _is_flashing:
		return

	_is_flashing = true
	sprite.modulate = Color(1, 0, 0)
	var tween := tree.create_tween()
	tween.tween_property(
		sprite,
		"modulate",
		Color(1, 1, 1),
		_flash_duration
	)
	tween.finished.connect(func():
		_is_flashing = false
	)
