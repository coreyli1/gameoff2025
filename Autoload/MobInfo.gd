extends Node

#enemy variables
#l2e1 = level 2 enemy 1
var level1 = {
	}
var level2 = {
	"enemy1": ["big",Vector2(300,400), "l2e1"],
	"enemy2": ["basic",Vector2(200,400), "l2e2"],
	"enemy3": ["big",Vector2(400,400), "l2e3"]
}	

var level3 = {
	
	
}

var level4 = {
	
	
}


# when an enemy dies, this array takes in informatioin
var defeated_enemies : Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_enemies():
	pass

func check_mob(mob):
	match mob:
		"basic":
			return preload("res://Game/Enemy/EnemyComponents/BasicEnemy.tscn")
		"big":
			return preload("res://Game/Enemy/BigSludge/BigSludge.tscn")
		"shooter":
			return preload("res://Game/Enemy/ShooterSludge/ShooterSludge.tscn")
