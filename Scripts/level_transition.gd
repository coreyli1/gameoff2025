@tool
class_name LevelTransition extends Area2D

enum SIDE {LEFT, RIGHT, TOP, BOTTOM}

@export_file ("*.tscn") var level
@export var target_transition_area : String = "LevelTransition"

@export_category("Collision Area Settings")
@export_range( 1, 12, 1, "or_greater" ) var size : int = 2 :
	set( _v ):
		size = _v
		_update_area()

@export var side: SIDE = SIDE.LEFT:
	set( _v ):
		size = _v
		_update_area()
		
		
@export var snap_to_grid : bool = false:
	set (_v):
		_snap_to_grid()	
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
		
	# dont want to monitor until player we've loaded
	monitoring = false	
	
	body_entered.connect( _player_entered )
	
func _player_entered(_p : Node2D):
	
	pass

func _update_area():
	var new_rect : Vector2 = Vector2(32,32)
	var new_position : Vector2 = Vector2.ZERO
	if side == SIDE_TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE_BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE_LEFT:
		new_rect.y *= size
		new_position.x -= 16	
	elif side == SIDE_RIGHT:
		new_rect.y *= size
		new_position.x += 16	
		
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position
	
	
func _snap_to_grid():
	#rounds x and y
	position.x = round(position.x/16) * 16
	position.y = round(position.y/16) * 16
	
