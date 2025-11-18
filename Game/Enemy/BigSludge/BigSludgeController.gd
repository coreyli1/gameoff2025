extends CharacterBody2D

@onready var stats: EnemyStats = $EnemyStats
@onready var wander: WanderBehavior = $WanderBehavior
@onready var chase: ChaseBehavior = $ChaseBehavior
@onready var detection_area: Area2D = $DetectionArea
@onready var alive : bool = true

var state := "wander"
var id

func _ready() -> void:
	add_to_group("enemies") 
	detection_area.connect("body_entered", Callable(self, "_on_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_body_exited"))
	stats.connect("died", Callable(self, "_on_enemy_died"))

func _physics_process(delta: float) -> void:
	if not alive:
		queue_free()
	match state:
		"wander":
			wander.update(self, stats, delta)
		"chase":
			chase.update(self, stats, delta)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		chase.player_ref = body
		state = "chase"

func _on_body_exited(body: Node) -> void:
	if body == chase.player_ref:
		chase.player_ref = null
		state = "wander"

func _on_enemy_died() -> void:
	queue_free()
