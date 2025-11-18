extends CharacterBody2D

@export var initial_state: String = "wander"
@onready var stats: EnemyStats = $EnemyStats
@onready var shoot: ShooterBehavior = $ShooterBehavior
@onready var wander: WanderBehavior = $WanderBehavior
@onready var detection_area: Area2D = $DetectionArea

var state := "wander"

func _ready() -> void:
	add_to_group("enemies") 
	detection_area.connect("body_entered", Callable(self, "_on_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_body_exited"))
	stats.connect("died", Callable(self, "_on_enemy_died"))

func _physics_process(delta: float) -> void:
	match state:
		"wander":
			wander.update(self, stats, delta)
		"shoot":
			shoot._physics_process(delta)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):	
		shoot.target = body
		state = "shoot"

func _on_body_exited(body: Node) -> void:
	if body == shoot.target:
		shoot.target = null
		state = "wander"

func _on_enemy_died() -> void:
	queue_free()
