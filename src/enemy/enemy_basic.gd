extends CharacterBody2D

# enemy stats
@export var enemy_HP: float = 100.0
@export var speed : float = 80.0
@export var gravity : float = 1200.0
@export var detect_range : float = 500.0
@export var attack_cooldown : float = 0.8 # time between attacks
@export var attack_damage_min : int = 8 # damage dealt
@export var attack_damage_max : int = 12
@export var wander_time_min : float = 0.5 # wandering time
@export var wander_time_max : float = 1.5
@export var stop_distance_min : float = 20.0 # distance before stopping near target
@export var stop_distance_max : float = 55.0
@export var attack_range_max : float = 60.0 # distance to stop attacking
# death timers
@export var dead_timer := 5.0 # time before getting deleted AFTER death
@export var dead_fall_velocity : float = 5.0 # death falling speed
# various states
enum State { WANDER, CHASE, ATTACK, DEAD }
var state: int = State.WANDER

# for damage flash
@export var flash_duration := 0.2
var is_flashing := false
# other internal values/timers
var target: Node2D = null
var attack_timer := 0.0
# for wandering
var enemy_direction : float = 0.0
var enemy_change_time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$AnimatedSprite2D.play("enemy_move")
	add_to_group("enemy") # add to unit group

func state_wander(delta: float) -> void:
	enemy_change_time -= delta
	if enemy_change_time <= 0.0:
		enemy_direction = [-1, 1].pick_random()
		enemy_change_time = randf_range(wander_time_min, wander_time_max)
	# horizontal
	velocity.x = enemy_direction * speed
	#try to find target
	target = EnemyHelper.find_nearest_player_unit(get_tree(), global_position, detect_range)
	if (target != null):
		state = State.CHASE
		velocity.x = 0;
		
func state_chase(delta: float) -> void:
	# if no target, go back to wander state
	if target == null:
		state = State.WANDER
		return
		
	var to_target := target.global_position - global_position
	var dist := to_target.length()
	# if target too far -> stop chasing
	if dist > detect_range:
		target = null
		state = State.WANDER
		return
		
	# keep moving until random stop distance
	var stop_dist := randf_range(stop_distance_min, stop_distance_max)
	if dist <= stop_dist:
		velocity.x = 0.0
		state = State.ATTACK
		return
		
	# move towards target
	var dir : float = sign(to_target.x)
	velocity.x = dir * speed
		
		
func state_attack(delta: float) -> void:
	if target == null:
		state = State.WANDER
		return
	
	var dist := global_position.distance_to(target.global_position)
	# target too far, back to wandering
	# target out of attack range -> wander again -> find new target
	if dist > attack_range_max:
		target = null
		state = State.WANDER
		$AnimatedSprite2D.play("enemy_move")
		return
		
	# target in attack range
	velocity.x = 0.0
	if $AnimatedSprite2D.animation != "enemy_attack":
		$AnimatedSprite2D.play("enemy_attack")
	# attacking
	attack_timer -= delta
	if attack_timer <= 0.0:
		attack_timer = attack_cooldown
		# apply damage ONCE per cooldown
		if target.has_method("take_damage"):
			target.take_damage(randi_range(attack_damage_min, attack_damage_max))

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
	if state == State.DEAD:
		return
	enemy_HP -= amount
	DamageHelper.flash_red($AnimatedSprite2D, get_tree(), is_flashing, flash_duration)
	if enemy_HP <= 0:
		enemy_HP = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (enemy_HP <= 0.0):
		# stop movement + stop targeting/ai
		velocity.x = 0.0
		target = null
		enemy_direction = 0.0
		# disable collisions so it does not block anything
		if has_node("CollisionShape2D"):
			$CollisionShape2D.disabled = true
		state = State.DEAD
	
	if state == State.DEAD:
		state_dead(delta)
		return
	
	if state == State.WANDER:
		state_wander(delta)
		
	elif state == State.CHASE:
		state_chase(delta)
		
	elif state == State.ATTACK:
		state_attack(delta)
	
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0
	# flip sprite
	if state == State.WANDER:
		if enemy_direction != 0:
			$AnimatedSprite2D.flip_h = enemy_direction < 0
	else:
		if target != null:
			$AnimatedSprite2D.flip_h = target.global_position.x < global_position.x
	
	move_and_slide()
