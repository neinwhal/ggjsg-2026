extends CharacterBody2D

# friendly stats
@export var friendly_HP : float = 300.0
@export var friendly_max_HP : float = 300.0
@export var speed : float = 90.0
@export var gravity : float = 1200.0
@export var detect_range : float = 750.0
@export var attack_cooldown : float = 0.8
@export var do_splash_dmg : bool = false
@export var attack_damage_min : int = 10 # damage dealt
@export var attack_damage_max : int = 35
@export var chase_max_distance : float = 550.0 # stop chasing after exceeding this distance
@export var wander_time_min : float = 0.0 # wandering time
@export var wander_time_max : float = 1.0
@export var idle_time_min : float = 2.0 # idle time
@export var idle_time_max : float = 5.0
@export var idle_speed_multiplier : float = 0.25 # multipler when wandering idle
@export var stop_distance_min : float = 15.0 # distance before stopping near target
@export var stop_distance_max : float = 50.0
@export var attack_range_max : float = 60.0 # distance to stop attacking
# follow variables
var desired_distance := 0.0
@export var follow_distance : float = 350.0
@export var follow_trigger_deviation : float = 5.0 # how far away from follow distance to trigger follow
@export var follow_speed_multiplier : float = 4.0 # multiplier when following
@export var distance_variation := 128.0
@export var follow_stop_buffer := 8.0   # pixels of tolerance
# hitbox
@onready var hitbox: Area2D = $AttackHitbox
# death timers
@export var dead_timer := 5.0 # time before getting deleted AFTER death
@export var dead_fall_velocity : float = 5.0 # death falling speed
# various states
var state: int = FriendlyHelper.State.IDLE
# for damage flash
@export var flash_duration := 0.2
var is_flashing := false
# other internal values/timers
var target_player: Node2D = null
var target_enemy: Node2D = null
var attack_timer := 0.0
# for wandering
var friendly_direction : float = 0.0
var friendly_change_time : float = 0.0

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
	$AnimatedSprite2D.play("idle")
	$Indicator.visible = false
	$Indicator.play("default")
	hitbox.monitoring = true
	hitbox.monitorable = false

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

func state_idle(delta: float) -> void:
	#print("IDLEMAN")
	# if too far from player, change to follow state
	var dist_to_player := global_position.distance_to(target_player.global_position)
	if dist_to_player > (follow_distance + follow_trigger_deviation):
		state = FriendlyHelper.State.FOLLOW
		return
	# if got enemies nearby change to chase state
	var nearby_enemy := _find_nearest_in_group("enemy", detect_range)
	if nearby_enemy != null:
		target_enemy = nearby_enemy
		state = FriendlyHelper.State.CHASE
		return
	# idle state, just walk ard/stand still
	friendly_change_time -= delta
	if friendly_change_time <= 0.0:
		friendly_direction = [-1, 1, 2, 3].pick_random()
		if (friendly_direction > 2):
			friendly_change_time = randf_range(idle_time_min, idle_time_max)
		else:
			friendly_change_time = randf_range(wander_time_min, wander_time_max)
	# horizontal movement
	if (friendly_direction > 1):
		velocity.x = 0.0
	else:
		velocity.x = friendly_direction * (speed * idle_speed_multiplier)
	
func state_follow(delta: float) -> void:
	#print("FOLLOWMAN")
	# horizontal follow logic
	var dx = target_player.global_position.x - global_position.x
	var abs_dx = abs(dx)
	var target_vx := 0.0
	if abs_dx > desired_distance + follow_stop_buffer:
		target_vx = sign(dx) * speed
	elif abs_dx < desired_distance - follow_stop_buffer:
		target_vx = 0.0
		state = FriendlyHelper.State.IDLE
		return;
		
	velocity.x = move_toward(velocity.x, target_vx, speed * follow_speed_multiplier * delta)

func select_unit() -> void:
	$Indicator.visible = true
	
func deselect_unit() -> void:
	$Indicator.visible = false

func state_order_move(delta: float) -> void:
	#print("ORDERMAN")
	velocity.x = 0
	# clear all targets!
	if target_enemy != null:
		target_enemy = null
	# logic for orders are in selection manager!
	# todo maybe move here so its easier to configure for each unit type? idkkk
	
func state_order_attack(delta: float) -> void:
	#print("attack order!")
	if target_enemy == null:
		state = FriendlyHelper.State.IDLE
		return
		
	var to_target := target_enemy.global_position - global_position
	var dist := to_target.length()
	# keep moving until random stop distance
	var stop_dist := randf_range(stop_distance_min, stop_distance_max)
	if dist <= stop_dist:
		velocity.x = 0.0
		state = FriendlyHelper.State.ATTACK
		return
	# move towards target
	var dir : float = sign(to_target.x)
	velocity.x = dir * speed
	
	
func state_chase(delta: float) -> void:
	#print("CHASEMAN")
	# no target, go back to idle
	if target_enemy == null:
		state = FriendlyHelper.State.IDLE
		return
	
	var to_target := target_enemy.global_position - global_position
	var dist := to_target.length()
	# if target too far -> stop chasing
	if dist > chase_max_distance:
		target_enemy = null
		state = FriendlyHelper.State.IDLE
		return
	# keep moving until random stop distance
	var stop_dist := randf_range(stop_distance_min, stop_distance_max)
	if dist <= stop_dist:
		velocity.x = 0.0
		state = FriendlyHelper.State.ATTACK
		return
	# move towards target
	var dir : float = sign(to_target.x)
	velocity.x = dir * speed
	
	
func do_splash_attack() -> void:
	await get_tree().physics_frame
	var dmg := randi_range(attack_damage_min, attack_damage_max)
	# splash damage
	for body in hitbox.get_overlapping_bodies():
		if body != null \
		and body.is_in_group("enemy") \
		and body.has_method("take_damage"):
			body.take_damage(dmg)
	
func state_attack(delta: float) -> void:
	#print("ATTACKMAN")
	if target_enemy == null:
		state = FriendlyHelper.State.IDLE
		return
		
	var dist := global_position.distance_to(target_enemy.global_position)
	# target out of attack range -> target too far, back to idle
	if dist > attack_range_max:
		target_enemy = null
		state = FriendlyHelper.State.IDLE
		return
	
	# target in attack range
	velocity.x = 0.0
	if $AnimatedSprite2D.animation != "attack":
		$AnimatedSprite2D.play("attack")
	# attacking
	attack_timer -= delta
	if attack_timer <= 0.0:
		attack_timer = attack_cooldown
		if do_splash_dmg:
			do_splash_attack()
		else:
			if target_enemy.has_method("take_damage"):
				target_enemy.take_damage(randi_range(attack_damage_min, attack_damage_max))

func state_dead(delta: float) -> void:
	if is_on_floor():
		velocity.y = dead_fall_velocity
	else:
		velocity.y += gravity * delta

	velocity.x = 0.0
	move_and_slide()

	dead_timer -= delta
	if dead_timer <= 0.0:
		queue_free()

func take_damage(amount: int) -> void:
	if state == FriendlyHelper.State.DEAD:
		return
	friendly_HP -= amount
	DamageHelper.flash_red($AnimatedSprite2D, get_tree(), is_flashing, flash_duration)
	if friendly_HP <= 0:
		friendly_HP = 0

func _process(delta: float) -> void:
	# wait until player exists
	if target_player == null:
		find_player()
		return
		
	if (friendly_HP <= 0.0):
		# stop movement + stop targeting/ai
		velocity.x = 0.0
		target_enemy = null
		target_player = null
		# disable collisions so it does not block anything
		if has_node("CollisionShape2D"):
			$CollisionShape2D.disabled = true
		state = FriendlyHelper.State.DEAD
	
	if state == FriendlyHelper.State.DEAD:
		state_dead(delta)
		return
	
	if state == FriendlyHelper.State.IDLE:
		state_idle(delta)
	elif state == FriendlyHelper.State.FOLLOW:
		state_follow(delta)
	elif state == FriendlyHelper.State.ORDER_MOVE:
		state_order_move(delta)
	elif state == FriendlyHelper.State.ORDER_ATTACK:
		state_order_attack(delta)
	elif state == FriendlyHelper.State.CHASE:
		state_chase(delta)
	elif state == FriendlyHelper.State.ATTACK:
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
	if (state != FriendlyHelper.State.ORDER_MOVE):
		if (state != FriendlyHelper.State.ATTACK):
			if moving:
				var moving_right: bool = velocity.x > 0.0

				# If sprite faces LEFT by default, flip when moving right.
				# If sprite faces RIGHT by default, flip when moving left.
				sprite.flip_h = moving_right if flip_when_moving_right else (not moving_right)

				if sprite.animation != "move":
					sprite.play("move")
			else:
				if sprite.animation != "idle":
					sprite.play("idle")
		elif (state == FriendlyHelper.State.ATTACK):
			# attack state, just turn towards enemy
			# sprite.flip_h = target_enemy.global_position.x < global_position.x
			# determine facing from enemy position
			var facing_dir = -1 if target_enemy.global_position.x < global_position.x else 1
			sprite.flip_h = facing_dir < 0 # visual flip
			hitbox.scale.x = facing_dir # hitbox flip
		

	move_and_slide()
