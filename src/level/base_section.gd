extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#$Background.region_rect.size.x = get_viewport_rect().size.x * 2
	#$Background.region_rect.size.y = get_viewport_rect().size.x * 1.5
	## Region rect w and h
	#print_debug("background size: ", $Background.region_rect.size)
	#$Background.position.x = 0#get_viewport_rect().size.x / 2.0
	#$Background.position.y = 0#get_viewport_rect().size.y / 2.0
	#print_debug("background pos: ", $Background.position)
	
	#$Floor/CollisionShape2D.shape.size.x = get_viewport_rect().size.x * 2
	#$Floor/CollisionShape2D.shape.size.y = get_viewport_rect().size.y * 2
	## (2304, 1296)
	#print_debug("floor collide size: ", $Floor/CollisionShape2D.shape.size)
	#$Floor/Sprite2D.region_rect.size.x = get_viewport_rect().size.x * 2
	#$Floor/Sprite2D.region_rect.size.y = get_viewport_rect().size.y * 2
	## rect (0, 0, 2304, 1296)
	#print_debug("floor sprite size: ", $Floor/Sprite2D.region_rect.size)
	#$Floor.position.x = 0
	#$Floor.position.y = get_viewport_rect().size.y # (0, 648)
	#print_debug("floor pos: ", $Floor.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
