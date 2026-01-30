extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Background/CollisionShape2D.shape.size.x = get_viewport_rect().size.x #* 1.5
	#$Background/CollisionShape2D.shape.size.y = get_viewport_rect().size.x / 2.0
	$Background.region_rect.size.x = get_viewport_rect().size.x #* 1.5
	$Background.region_rect.size.y = get_viewport_rect().size.x / 2.0
	$Background.position.x = get_viewport_rect().size.x / 2.0
	$Background.position.y = get_viewport_rect().size.y / 2.0
	
	$Floor/CollisionShape2D.shape.size.x = get_viewport_rect().size.x #* 1.5
	$Floor/CollisionShape2D.shape.size.y = get_viewport_rect().size.x / 2.0
	$Floor/Sprite2D.region_rect.size.x = get_viewport_rect().size.x #* 1.5
	$Floor/Sprite2D.region_rect.size.y = get_viewport_rect().size.x / 2.0
	$Floor.position.x = get_viewport_rect().size.x / 2.0
	$Floor.position.y = get_viewport_rect().size.y
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
