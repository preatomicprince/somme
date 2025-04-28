class_name Game extends Node2D

@onready var game_ui : CanvasLayer = $"game ui"

var turn: int = 0
var character: int = 0#-1 # Index for characters var, starts at -1 as will be incremented upon start
var time: float = 0.0 # If we want time of day to change with turns
var day: int = 0 # Incremented if current player character survives to next day

###to make moving around the map easier with camera whislt testing
var left : bool = false
var right : bool = false
var up : bool = false
var down : bool = false
var cam_speed = 50

enum ARMIES{
	British = 0,
	German = 1
}

var map: Map

# Arrays containing all units, playable and unplayable
var british_units: Array = []
var german_units: Array = []
var units: Array[Array] = [british_units, german_units]

# List of playable characters filled with array containing index in british unit list
var characters: Array[int] = [0, 1]

# Vars for player character (pc), may move to seperate class if it gets clunky
var pc_path: Array = []

func _ready() -> void:
	map = $Map
	
	# Add units to units var
	var map_child_count: int = map.get_child_count()
	for i in range(0, map_child_count):
		var new_child: Node2D = map.get_child(i)
		if new_child is Unit:
			pass

func _process(delta: float) -> void:
	var pc_ind: int = characters[character]
	var pc_unit: Unit = british_units[pc_ind]
	pc_unit.rotate_arrow()
	pc_unit.is_main_char = true ###makes sure that the pc_unit is the main char, which impacts other stuf 
	
	if left == true:
		$Camera2D.position.x -= cam_speed
	if right == true:
		$Camera2D.position.x += cam_speed
	if up == true:
		$Camera2D.position.y -= cam_speed
	if down == true:
		$Camera2D.position.y += cam_speed


func _input(event: InputEvent) -> void:
	
	
	if event.is_action_pressed("right click"):
		var pc_ind: int = characters[character]
		var pc_unit: Unit = british_units[pc_ind]
		var pc_tile: Vector2 = map.local_to_map(pc_unit.global_position)
		var mouse_tile: Vector2 = map.local_to_map(get_local_mouse_position())
		print("\nM: ", mouse_tile)
		var new_path: Array = self.map.generate_path(pc_tile, mouse_tile)
		"""var points = map.nav_grid.get_point_connections(map.get_tile_id(new_path[0]))
		
		for i in points:
			print(map.get_tile_pos(i))"""
				
		new_path.pop_front() # Removes first tile that pc is already stood on
		pc_path = new_path
		pc_unit.set_move_queue(new_path)
		#print(map.)

		
	
	
	if event.is_action_pressed("left"):
		left = true
		
	if event.is_action_pressed("right"):
		right = true
		
	if event.is_action_pressed("up"):
		up = true
		
	if event.is_action_pressed("down"):
		down = true
	
	if event.is_action_released("left"):
		left = false
		
	if event.is_action_released("right"):
		right = false
		
	if event.is_action_released("up"):
		up = false
		
	if event.is_action_released("down"):
		down = false
	
	if event.is_action("zoom in"):
		$Camera2D.zoom += Vector2(0.1, 0.1)
		
	if event.is_action("zoom out"):
		$Camera2D.zoom -= Vector2(0.1, 0.1)
		
	if event.is_action_pressed("right click"):
		var pc_ind: int = characters[character]
		var pc_unit: Unit = british_units[pc_ind]
		
		if pc_unit.get_input == false: # Skip if input already received
			return
			
		var pc_tile: Vector2 = map.local_to_map(pc_unit.global_position)
		var mouse_pos: Vector2 = get_local_mouse_position()
		
		
		if pc_unit.action_mode == Unit.ACTION_MODE.Move:
			var mouse_tile: Vector2 = map.local_to_map(mouse_pos)
			var new_path: Array = self.map.generate_path(pc_tile, mouse_tile)
			new_path.pop_front() # Removes first tile that pc is already stood on
			if len(new_path) <= pc_unit.max_moves: # Ensures can only move set distance
				pc_unit.set_move_queue(new_path)
				
		elif pc_unit.action_mode == Unit.ACTION_MODE.Attack:
			pc_unit.set_bullet(mouse_pos)
