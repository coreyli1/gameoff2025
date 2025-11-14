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
var initialized := false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_room()
	pass

func setup_room():
	if initialized:
		return
	initialized = true
	
	spawn_environment()
	spawn_mobs()
	pause_room()
	

func spawn_environment():
	for item in environment:
		var to_add = get_environment_type(item[0]).instantiate()
		var x = item[1]
		var y = item[2]
		to_add.position = Vector2(x,y)

		add_child(to_add)
		
func spawn_mobs():
	for mob in mobs:
		var to_add = get_mob_type(mob[0]).instantiate()
		var x = mob[1]
		var y = mob[2]
		to_add.position = Vector2(x,y)

		add_child(to_add)

func _on_west_door_body_entered(body: Node2D) -> void:
	print("west door entered, we are in current room", LevelManager.current_room)
	if body.is_in_group("player"):
		if westdoor:
			print(westdoor)

	
			LevelManager.switch_rooms("west",westdoor)			

func _on_east_door_body_entered(body: Node2D) -> void:
	print("east door entered, we are in current room", LevelManager.current_room)
	
	if body.is_in_group("player"):
		if eastdoor:
			print(eastdoor)

			LevelManager.switch_rooms("east",eastdoor)			

func _on_north_door_body_entered(body: Node2D) -> void:
	print("north door entered, we are in current room", LevelManager.current_room)
	if body.is_in_group("player"):
		if northdoor:
			print(northdoor)
		
			LevelManager.switch_rooms("north",northdoor)				

func _on_south_door_body_entered(body: Node2D) -> void:
	print("south door entered, we are in current room", LevelManager.current_room)
	if body.is_in_group("player"):
		if southdoor:
			print(southdoor)

			LevelManager.switch_rooms("south", southdoor)			

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


func pause_room():
	print("pause", LevelManager.current_room)
	for mob in get_tree().get_nodes_in_group("enemies"):
		if mob.is_inside_tree() and is_ancestor_of(mob):
			mob.set_process(false)
			mob.set_physics_process(false)
			for shape in mob.get_children():
				if shape is CollisionShape2D:
					shape.set_deferred("disabled", true)
					
	for item in get_tree().get_nodes_in_group("environment"):
		if item.is_inside_tree():
			for shape in item.get_children():
				if shape is CollisionShape2D:
					shape.set_deferred("disabled", true)
					
	for child in get_children():
		if child.has_signal("body_entered"):
			child.get_child(0).set_deferred("disabled", true)


func resume_room():
	print("resume", LevelManager.current_room)
	for mob in get_tree().get_nodes_in_group("enemies"):
		if mob.is_inside_tree() and is_ancestor_of(mob):
			mob.set_process(true)
			mob.set_physics_process(true)
			for shape in mob.get_children():
				if shape is CollisionShape2D:
					shape.set_deferred("disabled", false)
					
	for item in get_tree().get_nodes_in_group("environment"):
		if item.is_inside_tree():
			for shape in item.get_children():
				if shape is CollisionShape2D:
					shape.set_deferred("disabled", false)
					
	for child in get_children():
		if child.has_signal("body_entered"):
			print(child.get_child(0))
			child.get_child(0).set_deferred("disabled", false)
		
		
