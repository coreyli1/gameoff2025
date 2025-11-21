extends Control

var health_label : Label
var powerup_label : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	health_label = $CanvasLayer/GridContainer/Panel/health
	powerup_label = $CanvasLayer/GridContainer/Panel/powerup
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_weapons(powerup):
	powerup_label.text = "Light Ray: " + powerup

func update_health(health):
	print(health)
	health_label.text = "Health: " + str(health)
