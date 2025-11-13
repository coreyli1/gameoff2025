extends Node
class_name ShooterBehavior

@export var bullet_scene: PackedScene
@export var fire_rate: float = 2
@export var bullet_speed: float = 200.0
@export var detection_radius: float = 200.0
@export var damage: int = 2

var parent: Node2D
var fire_cooldown := 0.0
var target: Node2D = null


func _ready() -> void:
	parent = get_parent()
	target = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	fire_cooldown = max(0.0, fire_cooldown - delta)
	
	if not target:
		return
	
	var distance = parent.global_position.distance_to(target.global_position)
	if distance > detection_radius:
		return
		
	# Fire if ready
	if fire_cooldown <= 0.0:
		_shoot()
		fire_cooldown = fire_rate




func _shoot() -> void:
	if not bullet_scene or not target:
		return

	var bullet = bullet_scene.instantiate()
	var dir = (target.global_position - parent.global_position).normalized()

	bullet.global_position = parent.global_position
	bullet.direction = dir
	bullet.rotation = dir.angle()

	get_tree().current_scene.add_child(bullet)
