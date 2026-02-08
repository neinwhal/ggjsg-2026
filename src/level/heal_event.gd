extends Node2D

## Rescue mechanics
@export var trigger_duration: float = 3.0
@export var duration_step: float = 0.5
@export var heal_amount: float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealArea/InteractionTimer.set_timer(trigger_duration, duration_step)
	$HealArea/InteractionTimer.set_action_trigger("Interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_heal_area_body_entered(body: Node2D) -> void:
	if body is PlayerBasic:
		$HealArea/InteractionTimer.body_entered()


func _on_heal_area_body_exited(body: Node2D) -> void:
	if body is PlayerBasic:
		$HealArea/InteractionTimer.body_exited()


func _on_interaction_timer_on_time_timeout() -> void:
	## Perform heal event
	var players = get_tree().get_nodes_in_group("player")
	var units = get_tree().get_nodes_in_group("unit")
	for node in [players, units]:
		if "player_HP" in node:
			node.player_HP += heal_amount
		elif "friendly_max_HP" in node and "friendly_HP" in node:
			node.friendly_HP = min(node.friendly_max_HP, node.friendly_HP + heal_amount)
		else:
			print_debug(
				"Error: node '", 
				node.name, 
				"' in players or units group does not have both player_HP and friendly_max_HP!!!"
				)
