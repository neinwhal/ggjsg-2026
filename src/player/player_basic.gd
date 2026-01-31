extends CharacterBody2D
class_name PlayerBasic

# for damage flash
@export var flash_duration := 0.3
var is_flashing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player") # add to player group
	$Camera2D.make_current() # set camera to current
	$AnimatedSprite2D.play("player_idle")

@export var speed := 200.0
@export var jump_velocity := -400.0
@export var gravity := 1200.0
@export var player_HP : float = 1000;

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func take_damage(amount: int) -> void:
	if player_HP <= 0:
		return
		
	player_HP -= amount
	DamageHelper.flash_red($AnimatedSprite2D, get_tree(), is_flashing, flash_duration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_HP <= 0:
		### TODO: GAME OVER AND QUIT TO MAIN MENU	
		print("GAMEOVER!")
	
	# horizontal movement
	var dir := 0
	if Input.is_action_pressed("MoveLeft"):
		dir -= 1
	if Input.is_action_pressed("MoveRight"):
		dir += 1
	velocity.x = dir * speed

	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# jump
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide() # handles collision response

	# animation state
	if not is_on_floor():
		$AnimatedSprite2D.play("player_move")
	elif dir != 0:
		$AnimatedSprite2D.play("player_move")
	else:
		$AnimatedSprite2D.play("player_idle")

	# flip sprite based on direction
	if dir < 0:
		sprite.flip_h = true
	elif dir > 0:
		sprite.flip_h = false
