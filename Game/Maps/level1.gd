extends Node2D
var player: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player  = preload("uid://8acr486elffe").instantiate()
	print(player.position)
	add_child(player)
	if SceneChanger.previous_door == "":
		player.position = Vector2(420,250)
	else:
		position_player(SceneChanger.previous_door)	
	# if there is no previous door, then position him in the middle

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func position_player(door):
	# if previous door was x then position this vector
	
	match door:
		"north":
			player.position = Vector2(420,350)
		"east":
			player.position = Vector2(100,230)
		"south":
			player.position = Vector2(420,100)
		"west":
			player.position = Vector2(750,230)
