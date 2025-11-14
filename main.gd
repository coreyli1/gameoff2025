extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Player and RoomContainer are already in scene	
	LevelManager.setup($Player, $RoomContainer)
