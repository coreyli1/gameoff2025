extends CharacterBody2D

# Component references
@onready var stats: EnemyStats = $EnemyStats
@onready var wander: WanderBehavior = $WanderBehavior
@onready var charge: ChargeBehavior = $ChargeBehavior
@onready var pattern_shoot: PatternShootBehavior = $PatternShootBehavior
@onready var detection_area: Area2D = $DetectionArea

# State machine
enum State { WANDER, CHARGE, SHOOT }
var current_state: State = State.WANDER

# Target
var player_target: Node2D = null

# Timing
@export var wander_duration: float = 1.0
var state_timer := 0.0

func _ready() -> void:
	add_to_group("enemies")
	add_to_group("boss")
	
	# Connect signals
	detection_area.connect("body_entered", Callable(self, "_on_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_body_exited"))
	stats.connect("died", Callable(self, "_on_enemy_died"))
	
	# Connect behavior signals
	charge.connect("charge_hit_wall", Callable(self, "_on_charge_hit_wall"))
	charge.connect("charge_started", Callable(self, "_on_charge_started"))
	pattern_shoot.connect("shooting_complete", Callable(self, "_on_shooting_complete"))

func _physics_process(delta: float) -> void:
	if not is_physics_processing():
		return
	
	
	state_timer += delta
	
	match current_state:
		State.WANDER:
			wander.update(self, stats, delta)
			
			# After wandering for a bit, charge at player
			if state_timer >= wander_duration and player_target:
				change_state(State.CHARGE)
				
		State.CHARGE:
			var finished = charge.update(self, stats, delta)
			# ChargeBehavior will emit charge_hit_wall signal when done
			
		State.SHOOT:
			var finished = pattern_shoot.update(self, stats, delta)
			# PatternShootBehavior will emit shooting_complete signal

func change_state(new_state: State) -> void:
	# Exit current state
	match current_state:
		State.WANDER:
			pass
		State.CHARGE:
			charge.reset()
		State.SHOOT:
			pass
	
	# Enter new state
	current_state = new_state
	state_timer = 0.0
	
	match new_state:
		State.WANDER:
			print("BOSS: Wandering...")
		State.CHARGE:
			print("BOSS: Charging!")
			charge.start_charge(player_target)
		State.SHOOT:
			print("BOSS: Shooting pattern!")
			pattern_shoot.shoot_pattern(player_target)

# Signal handlers
func _on_charge_hit_wall() -> void:
	print("BOSS: Hit wall! Switching to shoot")
	change_state(State.SHOOT)

func _on_charge_started() -> void:
	# Optional: Visual feedback when charge actually starts
	flash_sprite()

func _on_shooting_complete() -> void:
	print("BOSS: Done shooting, back to wander")
	change_state(State.WANDER)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_target = body
		
		# If wandering and timer is up, start attacking
		if current_state == State.WANDER and state_timer >= wander_duration:
			change_state(State.CHARGE)

func _on_body_exited(body: Node) -> void:
	if body == player_target:
		player_target = null

func _on_enemy_died() -> void:
	print("BOSS DEFEATED!")
	queue_free()

func flash_sprite() -> void:
	var original = modulate
	modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	modulate = original
