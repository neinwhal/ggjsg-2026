extends Node2D

@export var move_speed := 150.0

var selected: Node2D = null
var target_pos: Vector2
var has_target := false

func _pick_unit_under_mouse(mouse_pos: Vector2) -> Node2D:
	var space_state := get_world_2d().direct_space_state

	# find colliders..
	var params := PhysicsPointQueryParameters2D.new()
	params.position = mouse_pos
	params.collide_with_areas = true
	params.collide_with_bodies = true
	# determine possible hits
	var hits := space_state.intersect_point(params, 32)
	# find first hit that belongs to "unit" group
	for h in hits:
		var collider: Object = h["collider"]

		if collider != null and collider.is_in_group("unit"):
			return collider as Node2D

	return null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos := get_global_mouse_position()

		# select a unit under mouse
		var unit := _pick_unit_under_mouse(mouse_pos)
		if unit != null:
			selected = unit
			has_target = false
			return

		# Otherwise, if something is selected, set destination
		if selected != null:
			target_pos = mouse_pos
			has_target = true

func _process(delta: float) -> void:
	if selected == null or not has_target:
		return
	
	# move towards x position
	var pos := selected.global_position
	pos.x = move_toward(pos.x, target_pos.x, move_speed * delta)

	selected.global_position = pos

	# Stop when close enough
	if selected.global_position.distance_to(target_pos) < 2.0:
		pos.x = target_pos.x
		selected.global_position = pos
		has_target = false
