extends Control

var health_label : Label
var powerup_label : Label
var levelroom_label : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	health_label = $CanvasLayer/GridContainer/Panel/health
	powerup_label = $CanvasLayer/GridContainer/Panel/powerup
	levelroom_label = $CanvasLayer/GridContainer/Panel/levelroom
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_weapons(powerup):
	powerup_label.text = "Light Ray: " + powerup

func update_health(health):
	print(health)
	health_label.text = "Health: " + str(health)

func update_levelroom(level,room):
	levelroom_label.text = "Level: " + level + " - " + "Room: " + room
		
