extends Node2D
var player: CharacterBody2D
const BASIC_ENEMY = preload("uid://c3ml3rncm83t7")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player  = preload("uid://8acr486elffe").instantiate()
	print(player.position)
	add_child(player)
	position_player(SceneChanger.previous_door)	


	
	spawn_mobs(MobInformation.level2)

	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_mobs(mobs):
	print(MobInformation.defeated_enemies)
	for mob in mobs:
		var arr = mobs[mob]
		if not MobInformation.defeated_enemies.has(arr[2]): #if the mob is not in the enemy defeated array
			var to_instantiate = MobInformation.check_mob(arr[0])
			var to_spawn = to_instantiate.instantiate()
			to_spawn.position = arr[1]
			to_spawn.id = arr[2]
			add_child(to_spawn)
			
			

func position_player(door):
	# if previous door was x then position this vector
	
	match door:
		"north":
			player.position = Vector2(420,350)
		"east":
			player.position = Vector2(100,230)
		"south":
			player.position = Vector2(420,100)
		"west":
			player.position = Vector2(750,230)
