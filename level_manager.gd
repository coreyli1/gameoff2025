extends Node2D


# Persistent reference to player
var player: CharacterBody2D

# Container in Main.tscn to hold all rooms
var room_container: Node2D

# Dictionary of all room instances keyed by room ID
var active_rooms := {}

# Current room ID
var current_room: String

var room_map = {}

enum level {
	TUTORIAL,
	ONE,
	TWO
}

var tutorial_map = {}

# doors = [n, e, s, w]
var level_one = {
	"r1": 
		{
			"doors": ["","","r3","r2"],
			"mobs":[],
			"environment":[
				["rock",500,150],				
				["rock",500,200],
				["rock",500,300],
				["breakable_rock",500,400],
				["rock",500,550],
				["rock",500,625],
				["rock",500,700],
				["rock",500,775],
				["rock",500,850]
				],
			"loot":[],
			"map_sprite": ""
		},
	"r2": 
		{
			"doors": ["","r1","",""],
			"mobs":[],
			"environment":[
				["rock",1100,175],				
				["rock",1100,250],
				["rock",1100,325],
				["rock",1100,400],
				["rock",1100,475],
				["rock",1100,550],
				["rock",1100,625],
				["rock",1100,700],
				["rock",1100,775],
				["rock",1100,850],
				
				["rock",1200,175],				
				["rock",1200,250],
				["rock",1200,325],
				["rock",1200,400],
				["rock",1200,475],
				["rock",1200,550],
				["rock",1200,625],
				["rock",1200,700],
				["rock",1200,775],
				["rock",1200,850],
				
				["rock",1300,175],				
				["rock",1300,250],
				["rock",1300,325],
				["rock",1300,400],
				["rock",1300,475],
				["rock",1300,550],
				["rock",1300,625],
				["rock",1300,700],
				["rock",1300,775],
				["rock",1300,850],
			],
			"loot":[],
			"map_sprite": ""
		},
	"r3": 
		{
			"doors": ["r1","r4","",""],
			"mobs":[
				["basic",400,500],
				["basic",300,900]
				],
			"environment":[
				
			],
			"loot":[],
			"map_sprite": ""
		},
	"r4": 
		{
			"doors": ["","","r5","r3"],
			"mobs":[
				
			],
			"environment":[],
			"loot":[],
			"map_sprite": ""
		},
	"r5": 
		{
			"doors": ["r4","","r6",""],
			"mobs":[
				
			],
			"environment":[],
			"loot":[],
			"map_sprite": ""
		},
	"r6": 
		{
			"doors": ["r5","","r7",""],
			"mobs":[
				["basic",800,500],
				["basic",1000,900],		
				["big",660,500],
				["basic",1000,550],
				["big",400,500],
				["basic",1500,600]			
			],
			"environment":[],
			"loot":[],
			"map_sprite": ""
		},
	"r7":
		{
			"doors": ["r6","","",""],
			"mobs":[	
			],
			"environment":[
				["stair",950, 500]
			],
			"loot":[],
			"map_sprite": ""			
		}
	
}
	
var level_two = {
	"r1": 
		{
			"doors": ["r3","","r2",""],
			"mobs":[],
			"environment":[
				["rock",700,150],				
				["rock",700,200],
				["rock",700,300],
				["rock",700,400],
				["rock",700,550],
				["rock",700,625],
				["rock",700,700],
				["rock",700,775],
				["rock",700,850]
				],
			"loot":[],
			"map_sprite": ""
		},
	"r2": 
		{
			"doors": ["","","r1",""],
			"mobs":[],
			"environment":[
			],
			"loot":[],
			"map_sprite": ""
		},
	"r3": 
		{
			"doors": ["r1","r4","",""],
			"mobs":[
				["basic",400,500],
				["basic",300,900]
				],
			"environment":[
				
			],
			"loot":[],
			"map_sprite": ""
		}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func setup(player_ref: CharacterBody2D, container_ref: Node2D):
	player = player_ref
	room_container = container_ref
	map_key(1)
	load_map(room_map)
	# By default, show first room
	current_room = "r1"
	_show_room(current_room)
	


func map_key(key):
	match key:
		level.TUTORIAL:
			room_map = tutorial_map
		level.ONE: 
			room_map = level_one
		level.TWO:
			room_map = level_two
			
			
func load_map(map):
	for r in map:
		# the dictionary we're parsing through
		var room_map = map[r]
		
		var room = preload("res://room.tscn").instantiate()
		room.visible = false
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
		
		room_container.add_child(room)		
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
		
func position_player(door):
	# if previous door was x then position this vector
	match door:
		"north":
			player.position = Vector2(931,850)
		"east":
			player.position = Vector2(350,550)
		"south":
			player.position = Vector2(931,150)
		"west":
			player.position = Vector2(1500,531)
	
			

func switch_rooms(entry_door: String, next_room: String ) -> void:
	print("switch rooms")
	print(current_room)
	print(active_rooms[current_room].westdoor)
	print(active_rooms[current_room].eastdoor)
	print(active_rooms[current_room].southdoor)
	print(active_rooms[current_room].northdoor)
	if not active_rooms.has(next_room):
		push_error("Room ID not found: %s" % next_room)
		return
	''
	# Hide current room
	if active_rooms.has(current_room):
		active_rooms[current_room].visible = false
		active_rooms[current_room].pause_room()
	
	# Show new room
	current_room = next_room
	_show_room(current_room)
	
	# Position player at the door used
	position_player(entry_door)

# Show a room
func _show_room(room_id: String) -> void:	
	print("show room")
	print(room_id)
	print(active_rooms[room_id].westdoor)
	print(active_rooms[room_id].eastdoor)
	print(active_rooms[room_id].southdoor)
	print(active_rooms[room_id].northdoor)
	if active_rooms.has(room_id):
		active_rooms[room_id].visible = true
		active_rooms[room_id].resume_room()
		for child in active_rooms[room_id].get_children():
			child.visible = true


func switch_levels():
	#remove level 1
	#spawn level 2
	pass
