extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





func _on_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		# we have an autoload player bullet thingy
		# if we do this then we give the player a gamma bullet
		# it turns green and can destroy things
		PlayerStats.bullet_color = Color.GREEN
		PlayerUI.update_powerup("Gamma")
		queue_free()
		pass
	pass # Replace with function body.
