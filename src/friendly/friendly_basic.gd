extends CharacterBody2D

@export var speed := 150.0
@export var gravity := 1200.0

var target: Node2D
var desired_distance := 0.0

@export var follow_distance := 256.0
@export var distance_variation := 128.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
		# Find the player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]

	# each friendly gets a slightly different stop distance
	desired_distance = follow_distance + randf_range(-distance_variation, distance_variation)

var direction : float = 0.0
var change_time : float = 0.0

@export var stop_buffer := 8.0   # pixels of tolerance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0
		
	# horizontal follow logic
	var dx = target.global_position.x - global_position.x
	var abs_dx = abs(dx)

	var target_vx := 0.0

	if abs_dx > desired_distance + stop_buffer:
		target_vx = sign(dx) * speed
	elif abs_dx < desired_distance - stop_buffer:
		target_vx = 0.0
	# else: stay as-is (dead zone)
	
	# Smooth acceleration / deceleration
	velocity.x = move_toward(velocity.x, target_vx, speed * 4.0 * delta)

	move_and_slide()
