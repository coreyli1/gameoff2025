extends CanvasLayer

var new_scene_path : String
var previous_door : String

func quick_switch(pathname):
	new_scene_path = pathname

func change_to(new_scene : Util.GAME_SCENES):
		print("change_to ", new_scene)
		match new_scene:
			Util.GAME_SCENES.GAME:
				new_scene_path = Util.GAME_PATH
			Util.GAME_SCENES.MENU:
				new_scene_path = Util.MENU_PATH
			Util.GAME_SCENES.LEVEL1:
				new_scene_path = Util.LEVEL1_PATH
				
				
func _new_scene():
	get_tree().call_deferred("change_scene_to_file", new_scene_path)
