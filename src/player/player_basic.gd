extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player") # add to player group
	$Camera2D.make_current() # set camera to current
	$AnimatedSprite2D.play("player_idle")

@export var speed := 200.0
@export var jump_velocity := -400.0
@export var gravity := 1200.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# horizontal movement
	var dir := 0
	if Input.is_key_pressed(KEY_A):
		dir -= 1
	if Input.is_key_pressed(KEY_D):
		dir += 1
	velocity.x = dir * speed

	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# jump
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide() # handles collision response

	# animation state
	if not is_on_floor():
		$AnimatedSprite2D.play("player_jump")
	elif dir != 0:
		$AnimatedSprite2D.play("player_move")
	else:
		$AnimatedSprite2D.play("player_idle")

	# flip sprite based on direction
	if dir < 0:
		sprite.flip_h = true
	elif dir > 0:
		sprite.flip_h = false
