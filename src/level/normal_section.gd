extends Node2D

func _ready() -> void:
	var texture_path: String = "res://assets/level/BG_TEMPLATE_level_%d.png"
	var random_number: int = Progression.rand.randi_range(1, 5)
	$MRTBackground.texture = load(texture_path % random_number)
	$MRTBackground.position.y = -40
	$MRTBackground.scale = Vector2(2,2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
