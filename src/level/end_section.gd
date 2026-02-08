extends Node2D

signal on_open_mrt_map_interacted()
signal on_mrt_map_exited()

## Rescue mechanics
@export var open_map_duration: float = 2.0
@export var duration_step: float = 0.2

func _ready() -> void:
	$ExitMrtMap/InteractionTimer.set_timer(open_map_duration, duration_step)
	$ExitMrtMap/InteractionTimer.set_action_trigger("OpenMap")

func _on_exit_mrt_map_body_entered(body: Node2D) -> void:
	$ExitMrtMap/InteractionTimer.body_entered()

func _on_exit_mrt_map_body_exited(body: Node2D) -> void:
	#_on_mrt_map_exited.emit()
	$ExitMrtMap/InteractionTimer.body_exited()
	on_mrt_map_exited.emit()


func _on_interaction_timer_on_time_timeout() -> void:
	on_open_mrt_map_interacted.emit()
	
	## Custom logic to hide timer after opening map
	$ExitMrtMap/InteractionTimer.hide_x_duration(0.6)
