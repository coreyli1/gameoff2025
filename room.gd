extends Node2D

var northdoor
var eastdoor
var southdoor
var westdoor

var mobs = []
var objects = []
var environment = []
var loot = []
var map_sprite : String




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Current Room: ", LevelManager.current_room)
	# spawn mobs

	for mob in mobs:
		var to_add = get_mob_type(mob[0]).instantiate()
		var x = mob[1]
		var y = mob[2]
		to_add.position = Vector2(x,y)

		add_child(to_add)

	# spawn environment
	
	for item in environment:
		var to_add = get_environment_type(item[0]).instantiate()
		var x = item[1]
		var y = item[2]
		to_add.position = Vector2(x,y)

		add_child(to_add)
		
	# spawn loot		
		
	for child in get_children():
		if child.is_in_group("environment"):
			print(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_west_door_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		if westdoor:
			print(westdoor)
			clear_map()
			LevelManager.position_player(body, "west")			
			LevelManager.switch_rooms(westdoor)			







func _on_east_door_body_entered(body: Node2D) -> void:

	
	if body.is_in_group("player"):
		if eastdoor:
			print(eastdoor)
			clear_map()
			LevelManager.position_player(body, "east")			
			LevelManager.switch_rooms(eastdoor)			





func _on_north_door_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		if northdoor:
			print(northdoor)
			clear_map()
			LevelManager.position_player(body, "north")			
			LevelManager.switch_rooms(northdoor)				





func _on_south_door_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		if southdoor:
			print(southdoor)
			clear_map()
			LevelManager.position_player(body, "south")			
			LevelManager.switch_rooms(southdoor)			




func get_mob_type(type):
	match type:
		"basic":
			print(type)			
			return preload("res://Game/Enemy/EnemyComponents/BasicEnemy.tscn")
		"big":
			print(type)			
			return preload("res://Game/Enemy/BigSludge/BigSludge.tscn")
		"shooter":
			print(type)			
			return preload("res://Game/Enemy/ShooterSludge/ShooterSludge.tscn")


func get_environment_type(type):
	match type:
		"rock":
			print(type)						
			return preload("res://Game/Environment/rock.tscn")
		"breakable_rock":
			print(type)			
			return preload("res://Game/Environment/breakable_rock.tscn")


func clear_map():
	for child in get_children():
		if child.is_in_group("environment"):
			child.queue_free()
		
