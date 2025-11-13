extends Area2D

@export var previous_door : String = "east"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




# connect it with itself!
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneChanger.quick_switch("res://Game/Maps/level1.tscn")
		SceneChanger._new_scene()
		SceneChanger.previous_door = previous_door

	pass # Replace with function body.
