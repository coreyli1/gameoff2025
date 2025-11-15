extends CharacterBody2D

@export var speed: float = 200.0
@export var shoot_cooldown: float = 0.3
@export var health = 10
@onready var frames: AnimatedSprite2D = $Frames

@onready var bullet_scene: PackedScene = preload("res://Game/Bullet/Bullet.tscn")
@onready var muzzle: Marker2D = $Muzzle


var can_shoot := true	
var num_bullets := 5



@onready var time := Time.get_ticks_msec
var last_tap_time = {
	"move_up": 0.0,
	"move_down": 0.0,
	"move_left": 0.0,
	"move_right": 0.0
}
var double_tap_threshold = 0.25

var is_dashing: bool = false
var dash_dir: Vector2 = Vector2.ZERO
@export var dash_speed: float = 1200.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.5
var can_dash: bool = true

func _ready() -> void:
	pass


func _process(_delta: float) -> void:

	if not is_dashing:
		move_player()
	else:
		move_and_slide()
	check_for_double_tap()
	
	if can_shoot:
		arrow_shoot()
		
	if Input.is_action_pressed("shoot") and can_shoot:
		aim_mouse()
		shoot()
		
	#set global variable of player position
	

func _on_hurtbox_body_entered(body):
	if body.is_in_group("enemies"):  # make sure only enemies hurt player
		var damage = body.get_node("EnemyStats").damage
		take_damage(damage)

func check_for_double_tap() -> void:
	var current_time = Time.get_ticks_msec() / 1000.0  # Convert ms → seconds
	
	for action in last_tap_time.keys():
		if Input.is_action_just_pressed(action):
			var time_since_last = current_time - last_tap_time[action]
			
			if time_since_last < double_tap_threshold:
				match action:
					"move_up": start_dash(Vector2(0, -1))
					"move_down": start_dash(Vector2(0, 1))
					"move_left": start_dash(Vector2(-1, 0))
					"move_right": start_dash(Vector2(1, 0))
				
			
			last_tap_time[action] = current_time


func start_dash(direction: Vector2) -> void:
	is_dashing = true
	can_dash = false
	dash_dir = direction.normalized()
	
	# Temporarily override velocity
	velocity = dash_dir * dash_speed
	
	# Start dash duration
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	
	# Reset cooldown
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true
	
	
func move_player() -> void:
	var input_vec := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	match input_vec:
		Vector2(1,0):
			frames.flip_h = false
			frames.play("side")
		Vector2(-1,0):
			frames.flip_h = true
			frames.play("side")	
		Vector2(0,1):			
			frames.play("down")	
		Vector2(0,-1):
			frames.play("up")
		Vector2(0,0):
			frames.stop()	
	velocity = input_vec.normalized() * speed
	move_and_slide()

func arrow_shoot():
	var input_vec := Vector2(
		Input.get_action_strength("shoot_right") - Input.get_action_strength("shoot_left"),
		Input.get_action_strength("shoot_down") - Input.get_action_strength("shoot_up")
	)
	
	
	match input_vec:
		Vector2(1,0):
			
			frames.flip_h = false
			frames.play("side")
			muzzle.rotation = 0
			shoot()
		Vector2(-1,0):
			
			frames.flip_h = true
			frames.play("side")
			muzzle.rotation = deg_to_rad(180)
			shoot()				
		Vector2(0,1):
			
			frames.play("down")	
			muzzle.rotation = deg_to_rad(90)	
			shoot()	
		Vector2(0,-1):
			
			frames.play("up")
			muzzle.rotation = deg_to_rad(270)
			shoot()


func shoot() -> void:
	PlayerStats.player_position = global_position
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.rotation = muzzle.rotation
	#changing the color everytime its instantiated
	bullet.color = PlayerStats.bullet_color
	get_tree().current_scene.add_child(bullet)
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func aim_mouse():
	var mouse_pos = get_global_mouse_position()
	var diff = mouse_pos - global_position

	# Compare absolute distances
	if abs(diff.x) > abs(diff.y):
		# Horizontal aim
		if diff.x > 0:
			frames.flip_h = false
			frames.play("side")
			muzzle.rotation_degrees = 0    # Right
		else:
			frames.flip_h = true
			frames.play("side")
			muzzle.rotation_degrees = 180  # Left
	else:
		# Vertical aim
		if diff.y > 0:
			frames.play("down")	
			muzzle.rotation = deg_to_rad(90)
			muzzle.rotation_degrees = 90   # Down
		else:
			frames.play("up")
			muzzle.rotation = deg_to_rad(270)
			muzzle.rotation_degrees = 270  # Up

func take_damage(damage) -> void:
	# enemy collides with player
	# health depletes
	print("ouch!")
	health -= damage
	if health <= 0:
		print("you died!")
	PlayerUi.update_health(health)


func _on_dashbox_body_entered(body: Node2D) -> void:
	if is_dashing and body.is_in_group("rocks"):
		body.queue_free()
