extends CharacterBody2D

@export var speed := 500.0
@export var gravity := 1200.0
@export var lifetime := 3.0
@export var damage := 10

var life := 0.0

func _ready() -> void:
	randomize()
	$AnimatedSprite2D.play("default")

func _process(delta: float) -> void:
	life += delta
	if life >= lifetime:
		queue_free()
		return

	# gravity makes the arc
	velocity.y += gravity * delta

	move_and_slide()

func _on_hit(body: Node) -> void:
	if body != null and body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
