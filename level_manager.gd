extends Node2D

var map = {}

enum level {
	TUTORIAL,
	ONE,
	TWO
}


# doors = [n, e, s, w]
var tutorial_map = {
	"r1": 
		{
			"doors": ["","","r3","r2"],
			"mobs":[],
			"environment":[
				["rock",500,400],
				["rock",500,450],
				["rock",500,500],
				["rock",500,550],
				["rock",500,600],
				["rock",500,650],
				["rock",500,700],
				["rock",500,750],
				["rock",500,800],
				["rock",500,850],
				["rock",500,900],
				],
			"loot":[],
			"map_sprite": ""
		},
	"r2": 
		{
			"doors": ["","r1","",""],
			"mobs":[],
			"environment":[],
			"loot":[],
			"map_sprite": ""
		},
	"r3": 
		{
			"doors": ["r1","r4","",""],
			"mobs":[
				["basic",400,500],
				["basic",300,500]
				],
			"environment":[],
			"loot":[],
			"map_sprite": ""
		},
	"r4": 
		{
			"doors": ["","","r5","r3"],
			"mobs":[],
			"environment":[],
			"loot":[],
			"map_sprite": ""
		},
	"r5": 
		{
			"doors": ["r4","","r6",""],
			"mobs":[],
			"environment":[],
			"loot":[],
			"map_sprite": ""
		},
	"r6": 
		{
			"doors": ["r6","","",""],
			"mobs":[],
			"environment":[],
			"loot":[],
			"map_sprite": ""
		}
}

var active_rooms = {}
var current_room


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	
	map_key(0)
	load_map(map)
	
	#by default, load r1 for every map
	current_room = "r1"
	add_child(active_rooms[current_room	])
	
	
	


func map_key(key):
	match key:
		level.TUTORIAL:
			map = tutorial_map
			
			
func load_map(map):
	for r in map:
		# the dictionary we're parsing through
		var room_map = map[r]
		
		var room = preload("res://room.tscn").instantiate()
		#create room
		#create doors and attach them
		#create mobs
		#create environments
		#create loot
		#use map sprite
		print(room_map)
		print(room_map.doors)
		set_doors(room, room_map.doors)
		print(room_map.mobs)			
		set_objects(room.mobs, room_map.mobs)
	
		print(room_map.environment)	
		set_objects(room.environment, room_map.environment)
		
		print(room_map.loot)
		set_objects(room.loot, room_map.loot)
		
		print(room_map.map_sprite)
		room.map_sprite = room_map.map_sprite
		
		active_rooms[r] = room
	



func set_doors(room, doors):

	#north
	room.northdoor = doors[0]
	
	#east
	room.eastdoor = doors[1]
	
	#south
	room.southdoor = doors[2]
	
	#west
	room.westdoor = doors[3]


	
func set_objects(room, objects):
	for object in objects:
		room.append(object)
		
func position_player(player, door):
	# if previous door was x then position this vector
	match door:
		"north":
			player.position = Vector2(931,950)
		"east":
			player.position = Vector2(350,550)
		"south":
			player.position = Vector2(931,200)
		"west":
			player.position = Vector2(1450,531)

			

#changing scenes
func switch_rooms(room):
	prints(current_room, active_rooms[current_room])
	#remove current child
	remove_child(active_rooms[current_room])
	
	#TODO: add a transition
	
	# add new child
	current_room = room
	call_deferred("add_child", active_rooms[current_room])



	
