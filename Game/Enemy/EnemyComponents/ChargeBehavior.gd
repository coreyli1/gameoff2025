extends Node
class_name ChargeBehavior

# Charge settings
@export var charge_speed_max: float = 600.0     # Maximum speed at end of charge
@export var charge_speed_min: float = 100.0     # Starting speed
@export var acceleration: float = 800.0         # How fast it accelerates
@export var telegraph_duration: float = 0.5     # Warning time before charge

var target: Node2D = null
var charge_direction: Vector2 = Vector2.ZERO
var is_charging := false
var telegraph_timer := 0.0
var current_speed := 0.0  # Current charge speed

signal charge_hit_wall
signal charge_started

func update(enemy: CharacterBody2D, stats: Node, delta: float) -> bool:
	if not target:
		return false
	
	# Telegraph phase - show warning before charging
	if not is_charging and telegraph_timer < telegraph_duration:
		telegraph_timer += delta
		enemy.velocity = Vector2.ZERO  # Stand still while preparing
		enemy.move_and_slide()
		
		# Calculate direction during telegraph
		charge_direction = (target.global_position - enemy.global_position).normalized()
		return false
	
	# Start charging
	if not is_charging:
		is_charging = true
		current_speed = charge_speed_min  # Start at minimum speed
		emit_signal("charge_started")
	
	# Accelerate over time
	current_speed = min(current_speed + acceleration * delta, charge_speed_max)
	
	# Charge in straight line with current speed
	enemy.velocity = charge_direction * current_speed
	enemy.move_and_slide()
	
	# Check for collision
	if enemy.get_slide_collision_count() > 0:
		# Hit something!
		emit_signal("charge_hit_wall")
		reset()
		return true  # Charge complete
	
	return false  # Still charging

func reset() -> void:
	is_charging = false
	telegraph_timer = 0.0
	charge_direction = Vector2.ZERO
	current_speed = 0.0  # Reset speed

func start_charge(new_target: Node2D) -> void:
	target = new_target
	is_charging = false
	telegraph_timer = 0.0
	current_speed = 0.0  # Reset speed when starting new charge
