extends Node2D
var player: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player  = preload("uid://8acr486elffe").instantiate()

	add_child(player)
	position_player(SceneChanger.previous_door)	



func position_player(door):
	# if previous door was x then position this vector
	
	match door:
		"north":
			player.position = Vector2(420,350)
		"east":
			player.position = Vector2(100,250)
		"south":
			player.position = Vector2(420,100)
		"west":
			player.position = Vector2(750,250)
