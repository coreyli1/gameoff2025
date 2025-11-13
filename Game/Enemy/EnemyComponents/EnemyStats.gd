extends Node
class_name EnemyStats
#shooter sludge stats

# Stats editable in editor
@export var max_health: int = 3
@export var speed: float = 50.0
@export var damage: int = 1


var current_health: int

signal died

func _ready():
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		emit_signal("died")
