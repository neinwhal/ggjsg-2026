extends CharacterBody2D

@export var speed := 500.0
@export var gravity := 1200.0
@export var lifetime := 3.0
@export var damage := 10

var life := 0.0

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	# detect overlap hits via Area2D (player/unit)
	$Area2D.body_entered.connect(_on_area_body_entered)

func _process(delta: float) -> void:
	life += delta
	if life >= lifetime:
		queue_free()
		return

	# gravity makes the arc
	velocity.y += gravity * delta

	move_and_slide()

	# disappear upon hitting floor
	if get_slide_collision_count() > 0:
		queue_free()
		return

func _on_area_body_entered(body: Node) -> void:
	if body == null:
		return

	if body.is_in_group("player") or body.is_in_group("unit"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		print("hit something")
		queue_free()
