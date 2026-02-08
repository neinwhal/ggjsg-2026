extends Object
class_name FriendlyHelper

enum State { IDLE, FOLLOW, ORDER_MOVE, ORDER_ATTACK, CHASE, ATTACK, REPOSITION, TRANSFORM, TRANSFORM_BACK, DEAD }

static func is_enemy_valid(target: Node2D) -> bool:
	# check for instance validity
	if target == null: return false
	if not is_instance_valid(target): return false
	# check for hp
	if "enemy_HP" in target:
		if target.enemy_HP <= 0:
			return false
	# otherwise is valid
	return true

static func get_player(context: Node) -> Node2D:
	var players = context.get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0] as Node2D
	return null
