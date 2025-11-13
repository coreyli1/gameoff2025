extends Node2D

var current_map



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
	# instantiate tutorial scene and add it to the main scene
	# add a door signal that will call a function that will start the next level

	
	# tutorial gets the area2D node called door's body_entered function and connects it to the function
	# start_level_one

	


# when the player enters the door, then we will go to another map
func start_level_one(body : Node):
	
	#if the opject that enters the door area2D then the function going to level_1 will activate
	if body.name == "Player":
		SceneChanger.change_to(Util.GAME_SCENES.LEVEL1)
		SceneChanger._new_scene()
#		call_deferred("remove_child",current_map)
#		current_map = Util.LEVEL_1_SCENE.instantiate()
#		call_deferred("add_child", current_map)
 
