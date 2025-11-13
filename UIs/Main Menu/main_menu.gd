extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_start_game_pressed() -> void:
	hide()
	$"../SubViewportContainer".show()
	$"../PlayerUi".show()
