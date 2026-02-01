extends TextureRect

const IDEAL_MAP_FPS: int = 7
const MAP_FRAMES: int = 7

const DURATION_PER_FRAME: float = 1.0 / IDEAL_MAP_FPS
var map_spritesheet_width: int
var map_frame_width: int
var map_duration_count: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var atlas: AtlasTexture = texture as AtlasTexture
	## Hardcode size values since godot modifies size of atlas
	map_spritesheet_width = 896#texture.get_size().x
	map_frame_width = 128#map_spritesheet_width / MAP_FRAMES
	atlas.region.size.x = 128#map_frame_width
	atlas.region.size.y = 112#texture.get_size().y
	atlas.region.position.x = 0 # will change per frame
	atlas.region.position.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	map_duration_count += delta
	if map_duration_count >= DURATION_PER_FRAME:
		map_duration_count -= DURATION_PER_FRAME
		## Change to next frame
		var atlas: AtlasTexture = texture as AtlasTexture
		#print_debug("pos_x: ", atlas.region.position.x)
		#print(texture.get_size().x)
		if (atlas.region.position.x + map_frame_width) < map_spritesheet_width:
			atlas.region.position.x += map_frame_width
			#print_debug("+ width")
		else:
			atlas.region.position.x = 0
			#print_debug("reset pos")
