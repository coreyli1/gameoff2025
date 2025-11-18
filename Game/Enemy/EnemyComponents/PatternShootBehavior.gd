extends Node
class_name PatternShootBehavior

# Bullet settings
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 200.0

# Pattern types
enum Pattern { CIRCLE, SPIRAL, TARGETED_BURST, WAVE }
@export var pattern_type: Pattern = Pattern.CIRCLE

# Circle pattern
@export var circle_bullet_count: int = 8

# Spiral pattern
@export var spiral_bullet_count: int = 12
@export var spiral_rotations: float = 2.0

# Targeted burst
@export var burst_count: int = 3
@export var burst_spread_angle: float = 30.0  # degrees

var parent: Node2D
var is_shooting := false
var shoot_timer := 0.0
@export var shoot_duration: float = 1.0  # How long the shooting state lasts

signal shooting_complete

func _ready() -> void:
	parent = get_parent()

func update(_enemy: CharacterBody2D, _stats: Node, delta: float) -> bool:
	if not is_shooting:
		return false
	
	shoot_timer += delta
	
	# Stay still while shooting
	_enemy.velocity = Vector2.ZERO
	_enemy.move_and_slide()
	
	# Finish shooting after duration
	if shoot_timer >= shoot_duration:
		emit_signal("shooting_complete")
		is_shooting = false
		shoot_timer = 0.0
		return true  # Shooting complete
	
	return false  # Still shooting

func shoot_pattern(target: Node2D = null) -> void:
	if not bullet_scene:
		push_error("No bullet scene assigned!")
		return
	
	is_shooting = true
	shoot_timer = 0.0
	
	match pattern_type:
		Pattern.CIRCLE:
			_shoot_circle()
		Pattern.SPIRAL:
			_shoot_spiral()
		Pattern.TARGETED_BURST:
			if target:
				_shoot_targeted_burst(target)
			else:
				_shoot_circle()  # Fallback
		Pattern.WAVE:
			_shoot_wave()

func _shoot_circle() -> void:
	for i in range(circle_bullet_count):
		var angle = (2.0 * PI / circle_bullet_count) * i
		var direction = Vector2(cos(angle), sin(angle))
		_spawn_bullet(direction)

func _shoot_spiral() -> void:
	for i in range(spiral_bullet_count):
		var progress = float(i) / spiral_bullet_count
		var angle = progress * spiral_rotations * 2.0 * PI
		var direction = Vector2(cos(angle), sin(angle))
		_spawn_bullet(direction)

func _shoot_targeted_burst(target: Node2D) -> void:
	var base_direction = (target.global_position - parent.global_position).normalized()
	var base_angle = base_direction.angle()
	
	for i in range(burst_count):
		var offset = (i - burst_count / 2.0) * deg_to_rad(burst_spread_angle / burst_count)
		var angle = base_angle + offset
		var direction = Vector2(cos(angle), sin(angle))
		_spawn_bullet(direction)

func _shoot_wave() -> void:
	# Shoots bullets in a wave pattern (left to right)
	for i in range(circle_bullet_count):
		var progress = float(i) / circle_bullet_count
		var angle = -PI/2 + (progress * PI)  # -90° to +90°
		var direction = Vector2(cos(angle), sin(angle))
		_spawn_bullet(direction)

func _spawn_bullet(direction: Vector2) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = parent.global_position
	bullet.direction = direction
	bullet.rotation = direction.angle()
	
	# Set speed if the bullet has a speed property
	if "speed" in bullet:
		bullet.speed = bullet_speed
	
	parent.get_tree().current_scene.add_child(bullet)
