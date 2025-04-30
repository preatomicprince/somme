class_name Game extends Node2D

@onready var game_ui : CanvasLayer = $"game ui"
@onready var timer = $text_timer###so the tutorial texts dont keep coming up

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
var british_unit_count: int = 0
var british_unit_starts: Array = []
var german_units: Array = []
var units: Array[Array] = [british_units, german_units]

# List of playable characters filled with array containing index in british unit list
var characters: Array[int] = [0, 1]

# Vars for player character (pc), may move to seperate class if it gets clunky
var pc_path: Array = []
var pc_unit: Unit

func _ready() -> void:
	map = $Map
	
	# Add units to units var
	var map_child_count: int = map.get_child_count()
	for i in range(0, map_child_count):
		var new_child = map.get_child(i)
		if new_child is Unit:
			pass
			
	var pc_ind: int = randi_range(0, len(british_units)-1)

	pc_unit = british_units[pc_ind]

func _process(delta: float) -> void:
	if pc_unit == null:
		return
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
		
	if pc_unit.end_turn == true:
		for i in british_units:
			if i.end_turn == false:
				game_ui.turn_text.text = "ALLIES TURN"
				i.npc_state.update()
		for b in british_units:
			if b.end_turn == false:
				return
		for i in german_units:
			if i.end_turn == false:
				game_ui.turn_text.text = "ENEMIES TURN"
				i.npc_state.update()
	else:
		game_ui.turn_text.text = "YOUR TURN"
				
	for b in british_units:
		if b.end_turn == false:
			return
	for g in german_units:
		if g.end_turn == false:
			return
	pc_unit.next_turn()
	for b in british_units:
		b.next_turn()
	for g in german_units:
		g.next_turn()


func _input(event: InputEvent) -> void:
	if pc_unit == null:
		return

	if event.is_action_pressed("toggle shoot"):
		game_ui.toggle_aim_buts() ###toggles the aim buts in the UI, if you put the switching in here itll work
	
	if event.is_action_pressed("toggle stance"):
		game_ui.toggle_stance_buts()###again but for toggling stances
	
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
	
	if event.is_action_pressed("esc"):
		get_tree().quit() ###to exit the game
	
	if event.is_action("zoom in"):
		if $Camera2D.zoom < Vector2(0.5, 0.5):
			$Camera2D.zoom += Vector2(0.1, 0.1)
		
	if event.is_action("zoom out"):
		if $Camera2D.zoom > Vector2(0.2, 0.2):
			$Camera2D.zoom -= Vector2(0.1, 0.1)

	if event.is_action_pressed("right click"):
		print(map.local_to_map(get_local_mouse_position()))
		if pc_unit.get_input == false: # Skip if input already received
			return
			
		var pc_tile: Vector2 = map.local_to_map(pc_unit.global_position)
		var mouse_pos: Vector2 = get_local_mouse_position() 
		var surrounding_cells = map.get_surrounding_cells(pc_tile)
		
		
		if pc_unit.action_mode == Unit.ACTION_MODE.Move:
			var mouse_tile: Vector2 = map.local_to_map(mouse_pos)
			var new_path: Array = self.map.generate_path(pc_tile, mouse_tile)
			if map.curent_area == 0 and map.eng_inside == true:
				map.enter_no_mans_land()
				var next_tile = pc_tile + Vector2(4, -4)
				new_path = self.map.generate_path(pc_tile, next_tile)
			if map.curent_area == 0 and map.eng_inside == false:
				return
				
			new_path.pop_front() # Removes first tile that pc is already stood on
			if len(new_path) <= pc_unit.max_moves: # Ensures can only move set distance
				if map.curent_area == 1 and map.ger_inside == true:
					map.enter_german_trench()
				pc_unit.set_move_queue(new_path)
				
		elif pc_unit.action_mode == Unit.ACTION_MODE.Attack:
			pc_unit.set_bullet(mouse_pos)
			
	

func _on_text_timer_timeout() -> void:
	game_ui.tutorial_text = "[right]    ".format({})

func reset() -> void:
	var new_units = []
	map.reset()
	
	
	for i in british_unit_count:
		var new_brit = preload("res://Unit/unit.tscn").instantiate()
		map.add_child(new_brit)
		new_brit.set_start_pos(british_unit_starts[i])
		new_units.append(new_brit)
		
	for i in british_units:
		i.on_death()

	british_units = new_units
		
	var pc_ind: int = randi_range(0, len(british_units)-1)
	pc_unit = british_units[pc_ind]
	$Camera2D.position = pc_unit.position
