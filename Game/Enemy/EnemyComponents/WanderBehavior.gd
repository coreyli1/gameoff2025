extends Node
class_name WanderBehavior

@export var wander_speed_multiplier: float = 0.5
@export var change_interval: float = 2.0

var direction := Vector2.ZERO
var timer := 0.0

func _ready() -> void:
	# Give an initial random direction when scene starts
	_randomize_direction()
	# Optionally randomize the timer so not all enemies turn at once
	timer = randf_range(0.0, change_interval)

func update(enemy: CharacterBody2D, stats: Node, delta: float) -> void:
	timer += delta
	if timer >= change_interval:
		timer = 0.0
		_randomize_direction()

	enemy.velocity = direction * stats.speed * wander_speed_multiplier
	enemy.move_and_slide()

func _randomize_direction():
	var dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	while dir.length() < 0.2:  # avoid too-small directions
		dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	direction = dir.normalized()
