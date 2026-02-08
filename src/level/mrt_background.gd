extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	position.y = -40
	scale = Vector2(2,2)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
