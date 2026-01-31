extends CharacterBody2D

@export var speed := 80.0
@export var gravity := 1200.0

enum State { WANDER, CHASE, ATTACK }
var state: int = State.WANDER
var target: Node2D = null

@export var detect_range := 250.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$AnimatedSprite2D.play("enemy_move")
	add_to_group("enemy") # add to unit group

var direction : float = 0.0
var change_time : float = 0.0


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
	change_time -= delta
	if change_time <= 0.0:
		direction = [-1, 1].pick_random()
		change_time = randf_range(0.5, 1.5)
	# horizontal
	velocity.x = direction * speed
	#try to find target
	target = find_nearest_player_unit(detect_range)
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
	if dist > 250.0:
		target = null
		state = State.WANDER
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
	if target == null:
		state = State.WANDER
		return
	
	var dist := global_position.distance_to(target.global_position)
	# target too far, back to wandering
	if dist > 250.0:
		target = null
		state = State.WANDER
		$AnimatedSprite2D.play("enemy_move")
		return
		
	# target out of attack range -> wander again -> find new target
	if dist > 60.0:
		target = null
		state = State.WANDER
		$AnimatedSprite2D.play("enemy_move")
		return
		
	# target in attack range
	velocity.x = 0.0
	$AnimatedSprite2D.play("enemy_attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		if direction != 0:
			$AnimatedSprite2D.flip_h = direction < 0
	else:
		if target != null:
			$AnimatedSprite2D.flip_h = target.global_position.x < global_position.x
	
	move_and_slide()
