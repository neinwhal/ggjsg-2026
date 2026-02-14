extends TextureButton

## Animation State
enum NodeAnimation {
	UNLIGHTED,		# For non neighbouring nodes
	BLINKING,		# For neighbouring nodes
	GRAYED			# For nodes not possible to enter anymore
}

var color_diff: String

const NODE_FRAMES: int = 5
const NODE_FRAME_WIDTH: int = 16
const NODE_SPRITESHEET_WIDTH: int = 80
const IDEAL_NODE_FPS: int = 5

var duration_per_frame: float = 1.0 / IDEAL_NODE_FPS
var node_duration_count: float
var animation_state: NodeAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#texture_normal = red_texture
	
	animation_state = NodeAnimation.UNLIGHTED
	animation_state = NodeAnimation.BLINKING
	var atlas_normal: AtlasTexture = texture_normal
	atlas_normal.region.size.x = 16
	atlas_normal.region.size.y = 16
	atlas_normal.region.position.x = 0
	atlas_normal.region.position.y = 0
	
	node_duration_count = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match animation_state:
		NodeAnimation.UNLIGHTED:
			## Retain same colour
			self_modulate = Color(1,1,1,1)
			node_duration_count = 0.0
			var atlas_normal: AtlasTexture = texture_normal as AtlasTexture
			atlas_normal.region.position.x = 0
		NodeAnimation.BLINKING:
			## Retain same colour
			self_modulate = Color(1,1,1,1)
			node_duration_count += delta
			if node_duration_count >= duration_per_frame:
				node_duration_count -= duration_per_frame
				# Change to next frame
				var atlas_normal: AtlasTexture = texture_normal as AtlasTexture
				#print_debug("pos_x: ", atlas.region.position.x)
				#print(texture.get_size().x)
				if (atlas_normal.region.position.x + NODE_FRAME_WIDTH) < NODE_SPRITESHEET_WIDTH:
					atlas_normal.region.position.x += NODE_FRAME_WIDTH
					#print_debug("+ width")
				else:
					atlas_normal.region.position.x = 0
		NodeAnimation.GRAYED:
			## Mix with gray
			self_modulate = Color(0.5,0.5,0.5,1.0)
			node_duration_count = 0.0
			var atlas_normal: AtlasTexture = texture_normal as AtlasTexture
			atlas_normal.region.position.x = 0
		_:
			pass
			print_debug("Node in invalid state!!!")


func set_unlighted() -> void:
	disabled = true
	animation_state = NodeAnimation.UNLIGHTED

func set_blinking() -> void:
	disabled = false
	animation_state = NodeAnimation.BLINKING

func set_grayed() -> void:
	disabled = true
	animation_state = NodeAnimation.GRAYED
