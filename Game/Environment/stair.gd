extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	#activate level manager script to go to next level
	if body.is_in_group("player"):
		print("stair has received ",body)
		LevelManager.switch_levels(2)
