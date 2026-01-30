extends CharacterBody2D

@export var speed := 80.0
@export var gravity := 1200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$AnimatedSprite2D.play("enemy_move")

var direction : float = 0.0
var change_time : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_time -= delta
	if change_time <= 0.0:
		direction = [-1, 1].pick_random()
		change_time = randf_range(0.5, 1.5)

	# horizontal
	velocity.x = direction * speed

	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# flip sprite
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction < 0
	
	move_and_slide()
