extends Node2D

var possible_npcs: Array[String] = [
	"ALLYTANK",
	"RANGED",
	"ELITERANGED",
	"ELITEMELEE",
	"MELEE"
]
var file_path: String = "res://assets/level/%s_RESCUE.png"
var selected_name: String
const DESIRED_FPS: int = 5
var duration_per_frame: float = 1.0 / DESIRED_FPS
var duration_counter: float

## Rescue mechanics
const required_rescue_time: float = 7.0
var current_progress: float = 0.0
var in_rescue_range: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_number: int = Progression.rand.randi_range(0, 4)
	selected_name = file_path % possible_npcs[random_number]
	$Sprite2D.texture = load(selected_name)
	$Sprite2D.scale = Vector2(2,2)
	$Sprite2D.hframes = 4
	$Sprite2D.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	$".".position = Vector2(500,500)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	duration_counter += delta
	if duration_counter >= duration_per_frame:
		duration_counter -= duration_per_frame
		## Change frame
		if ($Sprite2D.frame + 1) == $Sprite2D.hframes:
			$Sprite2D.frame = 0
		else:
			$Sprite2D.frame += 1
	
	if in_rescue_range and Input.is_action_pressed("Rescue"):
		current_progress += delta
		if current_progress >= required_rescue_time:
			## Spawn relevant stuff here
			match selected_name:
				"ALLYTANK":
					pass
				"RANGED":
					pass
				"ELITERANGED":
					pass
				"ELITEMELEE":
					pass
				"MELEE":
					pass
			free()
	else:
		current_progress = 0.0


func _on_rescue_area_body_entered(body: Node2D) -> void:
	if body is PlayerBasic:
		in_rescue_range = true


func _on_rescue_area_body_exited(body: Node2D) -> void:
	if body is PlayerBasic:
		in_rescue_range = false
