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

var room_name


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
		
	if not room_name == "boss":
	# spawning rocks in doors if it doesn't have a rock
		if not northdoor:
			spawn_door_blocks("not north")
		if not eastdoor:
			spawn_door_blocks("not east")
		if not southdoor:
			spawn_door_blocks("not south")
		if not westdoor:
			spawn_door_blocks("not west")

	else:
		#if you're in a boss level, spawn blocks for all the doors
		spawn_door_blocks("not north")
		spawn_door_blocks("not east")
		spawn_door_blocks("not south")
		spawn_door_blocks("not west")
		
func spawn_mobs():
	for mob in mobs:
		var to_add = get_mob_type(mob[0]).instantiate()
		var x = mob[1]
		var y = mob[2]
		to_add.position = Vector2(x,y)	
		add_child(to_add)

func _on_west_door_body_entered(body: Node2D) -> void:

	# how do i prevent DOUBLE JUMPING??? need to remove collision or need to wait some how or need to move player right away?
	if body.is_in_group("player"):
		if westdoor:
			prints("westdoor", westdoor, LevelManager.current_room)

			LevelManager.switch_rooms("west",westdoor)			

func _on_east_door_body_entered(body: Node2D) -> void:

	
	if body.is_in_group("player"):
		if eastdoor:
			prints("eastdoor", eastdoor, LevelManager.current_room)

			LevelManager.switch_rooms("east",eastdoor)			

func _on_north_door_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		if northdoor:
			print(northdoor)
		
			LevelManager.switch_rooms("north",northdoor)				

func _on_south_door_body_entered(body: Node2D) -> void:

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
		"boss":
			print(type)
			return preload("res://Game/Enemy/BossSludge/BossSludge.tscn")


func get_environment_type(type):
	match type:
		"rock":
			print(type)						
			return preload("res://Game/Environment/rock.tscn")
		"breakable_rock":
			print(type)			
			return preload("res://Game/Environment/breakable_rock.tscn")
		"stair":
			print(type)
			return preload("res://Game/Environment/stair.tscn")
		"gamma":
			print(type)
			return preload("res://Game/Environment/gamma.tscn")


func pause_room():
	print("pause room ", LevelManager.current_room)
	for mob in get_tree().get_nodes_in_group("enemies"):
		if mob.is_inside_tree() and is_ancestor_of(mob):
			mob.set_process(false)
			mob.set_physics_process(false)
			for shape in mob.get_children():
				if shape is CollisionShape2D:
					shape.set_deferred("disabled", true)
					
	for item in get_tree().get_nodes_in_group("environment"):
		if item.is_inside_tree() and is_ancestor_of(item):
			for shape in item.get_children():
				if shape is CollisionShape2D:
					disable_all_shapes(item, true)
	# pausing doors
	for child in get_children():
		
		if child.has_signal("body_entered"):
			#prints("child", child, LevelManager.current_room)
			child.get_child(0).set_deferred("disabled", true)


func resume_room():
	print("resume room ", LevelManager.current_room)
	for mob in get_tree().get_nodes_in_group("enemies"):
		if mob.is_inside_tree() and is_ancestor_of(mob):
			mob.set_process(true)
			mob.set_physics_process(true)
			for shape in mob.get_children():
				if shape is CollisionShape2D:
					shape.set_deferred("disabled", false)
					
	for item in get_tree().get_nodes_in_group("environment"):
		if item.is_inside_tree() and is_ancestor_of(item):
			for shape in item.get_children():
				if shape is CollisionShape2D:
					shape.set_deferred("disabled", false)
	# resuming doors
	for child in get_children():
		if child.has_signal("body_entered"):
			#prints("child", child, LevelManager.current_room)
			child.get_child(0).set_deferred("disabled", false)


func disable_all_shapes(node: Node, disabled: bool):
	for child in node.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", disabled)
		disable_all_shapes(child, disabled) # recurse

func spawn_door_blocks(direction):
	match direction:
		"not north":
			var x = 900
			for i in 3:
				var to_add = get_environment_type("rock").instantiate()
				to_add.position = Vector2(x,100)
				add_child(to_add)
				x+=50
		"not east":
			var y = 500
			for i in 3:
				var to_add = get_environment_type("rock").instantiate()
				to_add.position = Vector2(1650,y)
				add_child(to_add)
				y +=50
		"not south":
			var x = 900
			for i in 3:
				var to_add = get_environment_type("rock").instantiate()
				to_add.position = Vector2(x,900)
				add_child(to_add)
				x+=50
		"not west":
			var y = 500
			for i in 3:
				var to_add = get_environment_type("rock").instantiate()
				to_add.position = Vector2(250,y)
				add_child(to_add)
				y+=50
func despawn_door_blocks(direction):
	match direction:
		"not north":
			var x = 900
			for i in 3:
				
				var pos = Vector2(x,100)
				#if there is a rock in this position 
				for child in get_children():
					if child.position == pos:
						child.queue_free()

				x+=50
		"not east":
			var y = 500
			for i in 3:
				
				var pos = Vector2(1650,y)
				for child in get_children():
					if child.position == pos:
						child.queue_free()
				y +=50
		"not south":
			var x = 900
			for i in 3:
				
				
				var pos = Vector2(x,900)
				for child in get_children():
					if child.position == pos:
						child.queue_free()


				x+=50
		"not west":
			var y = 500 
			for i in 3:
				
				var pos = Vector2(250,y)
				for child in get_children():
					if child.position == pos:
						child.queue_free()

				y+=50

func on_boss_defeated():
	print("boss defeated")
	#unlock room based on the room configuration
	if northdoor:
		despawn_door_blocks("not north")
	if eastdoor:
		despawn_door_blocks("not east")
	if southdoor:
		despawn_door_blocks("not south")
	if westdoor:
		despawn_door_blocks("not west")

	
