extends Sprite2D

func _ready() -> void:
	var texture_path: String = "res://assets/level/MEGA_HORDE_BG_TEMPLATE_level_%d.png"
	var random_number: int = Progression.rand.randi_range(1, 5)
	texture = load(texture_path % random_number)
	position.y = -40
	scale = Vector2(2,2)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
