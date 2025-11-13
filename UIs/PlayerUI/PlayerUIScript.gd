extends Control

var health_label : Label
var powerup_label : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	health_label = $GridContainer/Panel/health
	powerup_label = $GridContainer/Panel/powerup
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_powerup(powerup):
	powerup_label.text = "PowerUp: " + powerup

func update_health(health):
	health_label.text = "Health: " + str(health)
	pass
