extends Area2D

@export var speed: float = 300.0
@export var damage: int = 1
var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	# Optional: rotate bullet sprite toward direction
	if direction != Vector2.ZERO:
		rotation = direction.angle()
		
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta

	# Optional: remove if off-screen
	if not get_viewport_rect().has_point(global_position):
		queue_free()


func _on_body_entered(body: Node) -> void:
	
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
