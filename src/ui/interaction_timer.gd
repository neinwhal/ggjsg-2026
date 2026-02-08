extends TextureProgressBar

var body_in_range: bool = false
var trigger_action: String = ""
signal on_time_timeout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not InputMap.has_action(trigger_action):
		print_debug("Invalid action state in InteractionTimer!!!")
		return
	
	if body_in_range and Input.is_action_pressed(trigger_action):
		if Input.is_action_just_pressed(trigger_action):
			## Reset timer
			$Timer.start()
		#else:
			## Let timer continue
	else:
		## Reset and stop timer
		$Timer.start()
		$Timer.stop()
	
	## Ensures progress bar counts up instead of down
	if $Timer.is_stopped():
		## $Timer.time_left is always set to 0 when stopped
		## Need to account for this special case
		## To avoid value being set to max
		value = 0.0
	else:
		value = $Timer.wait_time - $Timer.time_left

func set_timer(max_duration: float, _step: float = 1.0) -> void:
	max_value = max_duration
	step = _step
	$Timer.wait_time = max_duration

func set_action_trigger(action: String= "Rescue") -> void:
	trigger_action = action

func body_entered() -> void:
	body_in_range = true

func body_exited() -> void:
	body_in_range = false

func _on_timer_timeout() -> void:
	on_time_timeout.emit()
