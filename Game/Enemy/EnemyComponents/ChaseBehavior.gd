extends Node
class_name ChaseBehavior

var player_ref: Node2D = null

func update(enemy: CharacterBody2D, stats: Node, _delta: float) -> void:
	if player_ref:
		var dir = (player_ref.global_position - enemy.global_position).normalized()
		enemy.velocity = dir * stats.speed
		enemy.move_and_slide()
