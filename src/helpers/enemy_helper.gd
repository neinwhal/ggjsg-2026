extends Object
class_name EnemyHelper

enum State { WANDER, CHASE, ATTACK, REPOSITION, DEAD, DODGE, TRANSFORM }

static func find_nearest_player_unit(tree: SceneTree, from_pos: Vector2, max_dist: float) -> Node2D:
	var nearest: Node2D = null
	var nearest_dist_sq := max_dist * max_dist
	# combine both groups
	var candidates: Array = []
	candidates.append_array(tree.get_nodes_in_group("player"))
	candidates.append_array(tree.get_nodes_in_group("unit"))
	for node in candidates:
		if node == null or not (node is Node2D):
			continue
			
		var dist_sq := from_pos.distance_squared_to(node.global_position)
		if dist_sq <= nearest_dist_sq:
			nearest_dist_sq = dist_sq
			nearest = node
	return nearest
	
static func find_nearest_player_ranged(tree: SceneTree, from_pos: Vector2, max_dist: float) -> Node2D:
	var nearest: Node2D = null
	var nearest_dist_sq := max_dist * max_dist
	# combine both groups
	var candidates: Array = []
	candidates.append_array(tree.get_nodes_in_group("player"))
	candidates.append_array(tree.get_nodes_in_group("ranged"))
	for node in candidates:
		if node == null or not (node is Node2D):
			continue
			
		var dist_sq := from_pos.distance_squared_to(node.global_position)
		if dist_sq <= nearest_dist_sq:
			nearest_dist_sq = dist_sq
			nearest = node
	return nearest
