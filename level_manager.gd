extends Node2D


# Persistent reference to player
var player: CharacterBody2D

# Container in Main.tscn to hold all rooms
var room_container: Node2D

# Dictionary of all room instances keyed by room ID
var active_rooms := {}

# Current room ID
var current_room: String

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
				["breakable_rock",500,650],
				["rock",500,700],
				["rock",500,750],
				["rock",500,800],
				["rock",500,850],
				["rock",500,900],
				["rock",1500,900],
				["rock",1450,900],
				["rock",1450,900]
				
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
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# choose which map to load
	#map_key(level.TUTORIAL)

	# create and cache all room instances (but don't add them to tree yet)
	#load_map(map)

	# pick the starting room id (r1 by default)
	#current_room = "r1"

	# add initial room to the scene *after* _ready finishes to avoid nested tree changes
	#call_deferred("_add_initial_room")
	pass

func _add_initial_room() -> void:
	if not active_rooms.has(current_room):
		push_error("Starting room not found: %s" % current_room)
		return

	add_child(active_rooms[current_room])
	# ensure the room performs one-time setup (spawns env/mobs)
	if active_rooms[current_room].has_method("setup_room"):
		active_rooms[current_room].setup_room()
	


func setup(player_ref: CharacterBody2D, container_ref: Node2D):
	player = player_ref
	room_container = container_ref
	map_key(0)
	load_map(map)
	# By default, show first room
	current_room = "r1"
	_show_room(current_room)
	


func map_key(key):
	match key:
		level.TUTORIAL:
			map = tutorial_map
			
			
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
			player.position = Vector2(931,200)
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
