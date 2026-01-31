extends Node2D

@export var move_speed := 150.0
@export var drag_threshold := 8.0 # pixels before we treat it as a drag

var selected: Node2D = null
var target_pos: Vector2
var has_target := false

func select_unit_under_mouse(mouse_pos: Vector2) -> Node2D:
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
	
func select_units_in_rectangle(a: Vector2, b: Vector2) -> Array[Node2D]:
	var space_state := get_world_2d().direct_space_state
	# expand rectangle
	var rect := Rect2(a, Vector2.ZERO).expand(b)
	var center := rect.position + rect.size * 0.5 # center of rect
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	# find colliders
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D(0.0, center)
	# only scan the "units" layer 2
	params.collide_with_bodies = true
	params.collide_with_areas = true
	params.collision_mask = 2 # layer 2
	# determine possible hits
	var results := space_state.intersect_shape(params, 128)
	var out: Array[Node2D] = []
	for r in results:
		var collider: Object = r["collider"]
		if collider != null and collider.is_in_group("unit"):
			var n := collider as Node2D
			if n != null and not out.has(n):
				out.append(n)

	return out


var is_dragging := false
var drag_start := Vector2.ZERO
var drag_end := Vector2.ZERO
var selected_units: Array[Node2D] = []

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos := get_global_mouse_position()

		if event.pressed:
			drag_start = mouse_pos
			drag_end = mouse_pos
			is_dragging = false
			return
		else:
			# released
			if is_dragging:
				selected_units = select_units_in_rectangle(drag_start, drag_end)
				selected = selected_units[0] if selected_units.size() > 0 else null
				has_target = false
				
				is_dragging = false # stop drawing
				queue_redraw() # froce redraw to clear rectangle
				return

			# treat as a click (not a drag)
			var unit := select_unit_under_mouse(mouse_pos)
			if unit != null:
				selected = unit
				selected_units = [unit]
				has_target = false
				queue_redraw()
				return

			# click empty space: set destination if anything selected
			if selected_units.size() > 0:
				target_pos = mouse_pos
				has_target = true

	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			drag_end = get_global_mouse_position()
			if not is_dragging and drag_start.distance_to(drag_end) >= drag_threshold:
				is_dragging = true
			if is_dragging:
				queue_redraw()

func _process(delta: float) -> void:
	if selected == null or not has_target:
		return
	
	# move towards x position
	for u in selected_units:
		var pos := u.global_position
		var old_x := pos.x
		
		pos.x = move_toward(pos.x, target_pos.x, move_speed * delta)
		u.global_position = pos
		u.force_moving = true
		
		var dir_x := pos.x - old_x # negative = moved left, positive = moved right
		if absf(dir_x) > 0.001:
			var spr: AnimatedSprite2D = u.get_node("AnimatedSprite2D")
			if spr.animation != "bianlian_move":
				spr.play("bianlian_move")
			spr.flip_h = dir_x < 0.0

	# Stop when close enough
	# Stop when the "leader" is close enough on X
	var leader := selected_units[0]
	if abs(leader.global_position.x - target_pos.x) < 2.0:
		for u in selected_units:
			var p := u.global_position
			p.x = target_pos.x
			u.force_moving = false
			var spr: AnimatedSprite2D = u.get_node("AnimatedSprite2D")
			if spr.animation != "bianlian_idle":
				spr.play("bianlian_idle")
		has_target = false

func _draw() -> void:
	if is_dragging:
		var rect := Rect2(drag_start, Vector2.ZERO).expand(drag_end)
		draw_rect(rect, Color(0.2, 0.8, 1.0, 0.15), true)
		draw_rect(rect, Color(0.2, 0.8, 1.0, 0.9), false, 2.0)
