extends Area2D

@export var speed: float = 500.0
@export var color: Color = Color.WHITE
@export var damage: int = 1  # how much damage this bullet does

var direction: Vector2

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	$Sprite2D.modulate = color
	# Connect the area_entered signal to handle collisions
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	position += direction * speed * delta

	# if it is X distance away then queue_free

	if PlayerStats.player_position.distance_to(global_position) > 600:
		queue_free()

func _on_body_entered(body: Node) -> void:

	if body.is_in_group("player"):
		return
	# Only affect enemies
	if body.has_node("EnemyStats"):
		var enemy_stats = body.get_node("EnemyStats")
		enemy_stats.take_damage(damage)
		queue_free()  # destroy the bullet
		return

	if color == Color.GREEN and body.is_in_group("rocks"):
		body.die()
		queue_free()
		return
		
	if body is StaticBody2D:
		print("HIT WALL: ", body.name, " at position: ", body.global_position)
		print("Bullet was at: ", global_position)
		queue_free()
		return
func change_bullet_type(type):
	match type:
		"basic":
			color = Color.WHITE
			$Sprite2D.modulate = color
		"gamma":
			color = Color.GREEN
			$Sprite2D.modulate = color
