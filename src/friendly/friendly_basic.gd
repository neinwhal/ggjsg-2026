extends CharacterBody2D
class_name FriendlyBasic

@export var speed := 150.0
@export var gravity := 1200.0

@export var attack_cooldown := 0.8
@export var attack_damage := 10
var attack_timer := 0.0

enum State { IDLE, FOLLOW, ORDER, CHASE, ATTACK }
var friendly_HP = 200

var state: int = State.IDLE

var target_player: Node2D = null
var target_enemy: Node2D = null
var desired_distance := 0.0

@export var follow_distance := 350.0
@export var distance_variation := 128.0

func find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target_player = players[0] as Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("unit") # add to unit group
	randomize()
	find_player()
	# each friendly gets a slightly different stop distance
	desired_distance = follow_distance + randf_range(-distance_variation, distance_variation)
	# play default anim
	$AnimatedSprite2D.play("bianlian_idle")

var direction : float = 0.0
var change_time : float = 0.0

@export var stop_buffer := 8.0   # pixels of tolerance

func _find_nearest_in_group(group_name: String, max_dist: float) -> Node2D:
	var nearest: Node2D = null
	var nearest_dist := max_dist
	for n in get_tree().get_nodes_in_group(group_name):
		if n == self:
			continue
		var d := global_position.distance_to(n.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = n
	return nearest

var friendly_direction : float = 0.0
var friendly_change_time : float = 0.0
func state_idle(delta: float) -> void:
	#print("IDLEMAN")
	# if too far from player, change to follow state
	var dist_to_player := global_position.distance_to(target_player.global_position)
	if dist_to_player > (follow_distance + 5.0):
		state = State.FOLLOW
		return
	# if got enemies nearby change to chase state
	var nearby_enemy := _find_nearest_in_group("enemy", 175.0)
	if nearby_enemy != null:
		target_enemy = nearby_enemy
		state = State.CHASE
		return
	# idle state, just walk ard/stand still
	friendly_change_time -= delta
	if friendly_change_time <= 0.0:
		friendly_direction = [-1, 1, 2, 3].pick_random()
		if (friendly_direction > 2):
			friendly_change_time = randf_range(2.0, 5.0)
		else:
			friendly_change_time = randf_range(0.0, 1.0)
	# horizontal movement
	if (friendly_direction > 1):
		velocity.x = 0.0
	else:
		velocity.x = friendly_direction * (speed / 4.0)
	
func state_follow(delta: float) -> void:
	#print("FOLLOWMAN")
	# horizontal follow logic
	var dx = target_player.global_position.x - global_position.x
	var abs_dx = abs(dx)
	var target_vx := 0.0
	if abs_dx > desired_distance + stop_buffer:
		target_vx = sign(dx) * speed
	elif abs_dx < desired_distance - stop_buffer:
		target_vx = 0.0
		state = State.IDLE
		return;
		
	velocity.x = move_toward(velocity.x, target_vx, speed * 4.0 * delta)


func state_order(delta: float) -> void:
	#print("ORDERMAN")
	velocity.x = 0
	# logic for orders are in selection manager!
	# todo maybe move here so its easier to configure for each unit type? idkkk
	
func state_chase(delta: float) -> void:
	#print("CHASEMAN")
	# no target, go back to idle
	if target_enemy == null:
		state = State.IDLE
		return
	
	var to_target := target_enemy.global_position - global_position
	var dist := to_target.length()
	# if target too far -> stop chasing
	if dist > 110.0:
		target_enemy = null
		state = State.IDLE
		return
	# keep moving until random stop distance
	var stop_dist := randf_range(15.0, 50.0)
	if dist <= stop_dist:
		velocity.x = 0.0
		state = State.ATTACK
		return
	# move towards target
	var dir : float = sign(to_target.x)
	velocity.x = dir * speed
	
func state_attack(delta: float) -> void:
	#print("ATTACKMAN")
	if target_enemy == null:
		state = State.IDLE
		return
		
	var dist := global_position.distance_to(target_enemy.global_position)
	# target out of attack range -> target too far, back to idle
	if dist > 60.0:
		target_enemy = null
		state = State.IDLE
		return
	
	# target in attack range
	velocity.x = 0.0
	if $AnimatedSprite2D.animation != "bianlian_attack":
		$AnimatedSprite2D.play("bianlian_attack")
	# attacking
	attack_timer -= delta
	if attack_timer <= 0.0:
		attack_timer = attack_cooldown

		# apply damage ONCE per cooldown
		if target_enemy.has_method("take_damage"):
			target_enemy.take_damage(attack_damage)
		else:
			# fallback if you directly modify HP
			target_enemy.enemy_HP -= attack_damage

func _process(delta: float) -> void:
	# wait until player exists
	if target_player == null:
		find_player()
		return
	
	if state == State.IDLE:
		state_idle(delta)
	elif state == State.FOLLOW:
		state_follow(delta)
	elif state == State.ORDER:
		state_order(delta)
	elif state == State.CHASE:
		state_chase(delta)
	elif state == State.ATTACK:
		state_attack(delta)

	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# --- visuals (flip + anim) ---
	var sprite := $AnimatedSprite2D
	var flip_when_moving_right := false # set to false if your sprite faces right by default
	var moving: bool = abs(velocity.x) > 0.0
	if (state != State.ORDER):
		if (state != State.ATTACK):
			if moving:
				var moving_right: bool = velocity.x > 0.0

				# If sprite faces LEFT by default, flip when moving right.
				# If sprite faces RIGHT by default, flip when moving left.
				sprite.flip_h = moving_right if flip_when_moving_right else (not moving_right)

				if sprite.animation != "bianlian_move":
					sprite.play("bianlian_move")
			else:
				if sprite.animation != "bianlian_idle":
					sprite.play("bianlian_idle")
		elif (state == State.ATTACK):
			# attack state, just turn towards enemy
			sprite.flip_h = target_enemy.global_position.x < global_position.x
		

	move_and_slide()
