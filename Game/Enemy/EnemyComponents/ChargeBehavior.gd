extends Node
class_name ChargeBehavior

# Charge settings
@export var charge_speed: float = 400.0
@export var telegraph_duration: float = 0.5  # Warning time before charge

var target: Node2D = null
var charge_direction: Vector2 = Vector2.ZERO
var is_charging := false
var telegraph_timer := 0.0

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
		emit_signal("charge_started")
	
	# Charge in straight line
	enemy.velocity = charge_direction * charge_speed
	var collision = enemy.move_and_slide()
	
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

func start_charge(new_target: Node2D) -> void:
	target = new_target
	is_charging = false
	telegraph_timer = 0.0
