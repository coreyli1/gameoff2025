extends Area2D

@export var previous_door : String = "west"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneChanger.quick_switch("res://Game/Maps/level3.tscn")
		SceneChanger._new_scene()
		SceneChanger.previous_door = previous_door

	pass # Replace with function body.
