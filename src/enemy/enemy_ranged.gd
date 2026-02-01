extends CharacterBody2D

@export var enemy_HP : float = 13.0
@export var enemy_HP_max : float = 13.0
@export var speed : float = 80.0
@export var gravity : float = 1200.0
@export var detect_range := 800.0
@export var attack_cooldown = 4.8 # time between attacks
@export var attack_damage_min : int = 2 # damage dealt
@export var attack_damage_max : int = 3
@export var wander_time_min : float = 0.5 # wandering time
@export var wander_time_max : float = 1.5
@export var stop_distance_min : float = 220.0 # distance before stopping near target
@export var stop_distance_max : float = 280.0
@export var attack_range_min : float = 215.0 # distance to stop attacking
@export var attack_range_max : float = 285.0 # distance to stop attacking
# projectile stats
@onready var BulletScene: PackedScene = preload("res://src/enemy/enemy_projectile_ranged.tscn")
@export var bullet_spawn_offset := Vector2(20, -10)
@export var bullet_speed := 500.0
@export var bullet_arc_up := 280.0  # how "high" the arc starts
# death timers
@export var dead_timer := 5.0 # time before getting deleted AFTER death
@export var dead_fall_velocity : float = 5.0 # death falling speed
# various states
var state: int = EnemyHelper.State.WANDER

# for damage flash
@export var flash_duration := 0.2
var is_flashing := false
# other internal values/timers
var target: Node2D = null
var attack_timer = 0.0
# for wandering
var enemy_direction : float = 0.0
var enemy_change_time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$AnimatedSprite2D.play("enemy_move")
	add_to_group("enemy") # add to unit group

func find_nearest_player_unit(max_dist: float) -> Node2D:
	var nearest: Node2D = null
	var nearest_dist_sq := max_dist * max_dist
	# combine both groups
	var candidates: Array = []
	candidates.append_array(get_tree().get_nodes_in_group("player"))
	candidates.append_array(get_tree().get_nodes_in_group("unit"))
	for node in candidates:
		if node == null or not (node is Node2D):
			continue
			
		var dist_sq := global_position.distance_squared_to(node.global_position)
		if dist_sq <= nearest_dist_sq:
			nearest_dist_sq = dist_sq
			nearest = node
	return nearest

func state_wander(delta: float) -> void:
	enemy_change_time -= delta
	if enemy_change_time <= 0.0:
		enemy_direction = [-1, 1].pick_random()
		enemy_change_time = randf_range(wander_time_min, wander_time_max)
	# horizontal
	velocity.x = enemy_direction * speed
	#try to find target
	target = find_nearest_player_unit(detect_range)
	if (target != null):
		state = EnemyHelper.State.CHASE
		velocity.x = 0;
		
func state_chase(delta: float) -> void:
	# if no target, go back to wander state
	if target == null:
		state = EnemyHelper.State.WANDER
		return
		
	var to_target := target.global_position - global_position
	var dist := to_target.length()
	# if target too far -> stop chasing
	if dist > detect_range:
		target = null
		state = EnemyHelper.State.WANDER
		return
		
	# keep moving until random stop distance
	var stop_dist := randf_range(stop_distance_min, stop_distance_max)
	if dist <= stop_dist:
		velocity.x = 0.0
		state = EnemyHelper.State.ATTACK
		return
		
	# move towards target
	var dir : float = sign(to_target.x)
	velocity.x = dir * speed
		

func fire_bullet() -> void:
	if target == null:
		return

	var b := BulletScene.instantiate() as CharacterBody2D
	get_parent().add_child(b) # add to same parent as enemy (not as child)

	# spawn position
	var spawn_pos := global_position + bullet_spawn_offset
	b.global_position = spawn_pos

	# direction to target
	var to_target := (target.global_position - spawn_pos)
	var dir_x : float = sign(to_target.x)

	# initial velocity: forward + a bit upward for arc
	# (negative Y is up in Godot 2D)
	b.velocity = Vector2(dir_x * bullet_speed, -bullet_arc_up)

	# if your bullet script has damage, set it (optional)
	if "damage" in b:
		b.damage = randi_range(attack_damage_min, attack_damage_max)

func state_attack(delta: float) -> void:
	if target == null:
		state = EnemyHelper.State.WANDER
		return
	
	var dist := global_position.distance_to(target.global_position)
	# target too far, back to wandering
	if dist > detect_range:
		target = null
		state = EnemyHelper.State.WANDER
		$AnimatedSprite2D.play("enemy_move")
		return
		
	# target out of attack range -> wander again -> find new target
	if dist > attack_range_max:
		target = null
		state = EnemyHelper.State.WANDER
		$AnimatedSprite2D.play("enemy_move")
		return
		
#	if dist < attack_range_min:
#		state = EnemyHelper.State.REPOSITION
#		$AnimatedSprite2D.play("enemy_move")
#		return
		
	# target in attack range
	velocity.x = 0.0
	$AnimatedSprite2D.play("enemy_attack")
	# cooldown logic (example)
	attack_timer -= delta
	if attack_timer <= 0.0:
		attack_timer = attack_cooldown
		fire_bullet()

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
	if state == EnemyHelper.State.DEAD:
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
		state = EnemyHelper.State.DEAD
	
	if state == EnemyHelper.State.DEAD:
		state_dead(delta)
		return
	
	if state == EnemyHelper.State.WANDER:
		state_wander(delta)
		
	elif state == EnemyHelper.State.CHASE:
		state_chase(delta)
		
	elif state == EnemyHelper.State.ATTACK:
		state_attack(delta)
	
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0
	# flip sprite
	if state == EnemyHelper.State.WANDER:
		if enemy_direction != 0:
			$AnimatedSprite2D.flip_h = enemy_direction < 0
	else:
		if target != null:
			$AnimatedSprite2D.flip_h = target.global_position.x < global_position.x
	
	move_and_slide()
