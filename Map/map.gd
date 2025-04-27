class_name Map extends TileMapLayer

const MAP_SIZE = Vector2i(50, 50)

var custom_cursor_up = load("res://Res/UI Elements/custom cursers1.png")
var custom_cursor_down = load("res://Res/UI Elements/custom cursers5.png")

var barbed_wire_list : Array = [] #list of barbed wire to toggle visiblitiy with 
@onready var sandbag_list : Array = [$SandbagWall, $SandbagWall2, $SandbagWall3, $SandbagWall4] #list of sandbags to make visible ect
var tree_list : Array = [] #list of trees to make visible/invisible

@onready var english_trench : Sprite2D = $"English trench"
@onready var german_trench: Sprite2D = $"German trench"
@onready var no_mans_land : Sprite2D = $"No Mans Land"
@onready var bunker : Sprite2D = $MachineGunPost

var no_mans_land_vector : Vector2i = Vector2i(0, 0) #this is nmls vector cords
var barbed_wire_vector : Vector2i = Vector2i(0, 1) #this is to check if the tile is a barbed wire
var wall_vector : Vector2i = Vector2i(1, 1) #this is for the wall of the english trench, maybe clicking on it gets you to no mans land
var gun_post_vector : Vector2i = Vector2i(2, 1) #maybe used to check to destroy something idk

var game: Game

enum GAME_AREAS { ###an enum of the playing areas thall be used to change between areas.
	British_trench = 0,
	No_mans_land = 1,
	German_trench = 2
}

var curent_area : GAME_AREAS = 0 

var eng_inside : bool = false ###used to create a custom cursor, and switch between no mans land and the trench
var ger_inside : bool = false

var nav_grid: AStar2D

var units = []

func _ready() -> void:
	self.game = get_parent()
	
	# Set up nav_grid
	self.nav_grid = AStar2D.new()
	
	for y in range(0-MAP_SIZE.y, MAP_SIZE.y):
		for x in range(0-MAP_SIZE.x, MAP_SIZE.x):
			var new_tile_pos = Vector2i(x, y)
			var tile_id = get_tile_id(new_tile_pos)
			nav_grid.add_point(tile_id, new_tile_pos)
			
			units.append(null)
	
	# Connect tiles to the six surrounding tiles
	# Done here because all points must be set up first
	for y in range(-MAP_SIZE.y, MAP_SIZE.y):
		for x in range(-MAP_SIZE.x, MAP_SIZE.x):
			var tile_pos = Vector2i(x, y)
			var tile_id = get_tile_id(tile_pos)

			var surrounding_tiles = []
			
			##
			## Adds surrounding tiles while ensurings opposite ends of maps don't connect
			## Built-in function (get_surrounding_cells?) would connect non-touching tiles on other side sometimes
			##
			
			if tile_pos.x < MAP_SIZE.x - 1:
				surrounding_tiles.append(Vector2i(1,0))
		
			if tile_pos.y < MAP_SIZE.y - 1:
				surrounding_tiles.append(Vector2i(0, 1))
		
			if tile_pos.x < MAP_SIZE.x - 1 and tile_pos.y < MAP_SIZE.y - 1:
				surrounding_tiles.append(Vector2i(1, 1))
			#surrounding_tiles = get_surrounding_cells(tile_pos)
			
			for surrounding_tile in surrounding_tiles:
				var connected_id = get_tile_id(surrounding_tile + tile_pos)
					
				nav_grid.connect_points(tile_id, connected_id)
				
	# Snap units to tiles, add environment to lists
	for i in range(get_child_count()):
		var next_child = get_child(i)
		if next_child is Unit:
			var initial_pos: Vector2 = next_child.global_position
			var start_tile: Vector2 = local_to_map(initial_pos)
			var start_tile_ID: int = get_tile_id(start_tile)
			var start_pos: Vector2 = map_to_local(start_tile)
			
			next_child.set_start_pos(start_pos)
			units[start_tile_ID] = next_child
			
			# Add to correct troop list
			if next_child.army == Game.ARMIES.British:
				self.game.british_units.append(next_child)
			elif next_child.army == Game.ARMIES.German:
				self.game.german_units.append(next_child)
			
		if next_child is Trees:
			tree_list.append(next_child)
		if next_child is Barbed_Wire:
			barbed_wire_list.append(next_child)
			
	for s in sandbag_list:
		s.modulate = Color(0.45, 0.45, 0.45, 1.00)
		s.visible = true
	
func get_tile_id(tile_pos: Vector2i) -> int:
	"""
	Where needed, tiles have an unique integer id based on their position in the grid.
	Used for AStar2d navigation.
	"""
	return tile_pos.x + MAP_SIZE.x*tile_pos.y
	
func get_tile_pos(tile_id: int) -> Vector2i:
	"""
	Returns Vec2 of tile map points from a given tile id
	"""
	var tile_pos: Vector2i = Vector2i(0, 0)
	tile_pos.x = tile_id % MAP_SIZE.x
	tile_pos.y = (tile_id - tile_pos.x)/MAP_SIZE.x
	
	return tile_pos
	
func generate_path(start_tile: Vector2i, end_tile: Vector2i) -> Array:
	var start_id: int = get_tile_id(start_tile)
	var end_id: int = get_tile_id(end_tile)
	var path: Array = []
	
	var id_path: Array = nav_grid.get_id_path(start_id, end_id, true)
	
	for point in id_path:
		path.append(get_tile_pos(point))
	
	return path
			
func enter_no_mans_land() -> void:
	"""
	The point of this function is to reduce the alpha of non vital items whilst
	in no mans land
	"""
	curent_area = 1
	english_trench.modulate = Color(0.45, 0.45, 0.45, 1.00)
	no_mans_land.modulate = Color(1.00, 1.00, 1.00, 1.00)
	eng_inside = false
	Input.set_custom_mouse_cursor(null)
	
	for b in barbed_wire_list:
		b.modulate = Color(1.00, 1.00, 1.00, 1.00)
		
	for t in tree_list:
		t.modulate = Color(1.00, 1.00, 1.00, 1.00)
		
	for s in sandbag_list:
		s.modulate = Color(1.00, 1.00, 1.00, 1.00)
	
func enter_german_trench() -> void:
	"""
	This function makes no mans land and all its related detritus disapear.
	And increase the visibility of the german trench
	"""
	curent_area = 2
	german_trench.modulate = Color(1.00, 1.00, 1.00, 1.00) 
	no_mans_land.visible = false
	english_trench.visible = false
	
	ger_inside = false
	Input.set_custom_mouse_cursor(null)
	
	for b in barbed_wire_list:
		b.visible = false
		
	for t in tree_list:
		t.visible = false
		
	for s in sandbag_list:
		s.visible = false
	
func reset() -> void:
	
	curent_area = 0
	
	english_trench.visible = true
	no_mans_land.visible = true
	
	for barbed_wire in barbed_wire_list:
		barbed_wire.reset()
		
	for unit in self.game.british_units:
		unit.reset()
		
	for unit in self.game.german_units:
		unit.reset()

func _input(event: InputEvent) -> void:
	"""
	This function changes the tile type underneath barbed wire you're cutting,
	it also destroys the bunker at the moment.
	This'll all need changing so that characters move to the target, then do the thing. 
	I'm just testing certain things work
	"""
	
	if event.is_action_pressed("right click"):
		###changes to the no mans land if your in the english trench
		if curent_area == 0 and eng_inside == true:
			enter_no_mans_land()
		
		if curent_area == 1 and ger_inside == true:
			enter_german_trench()
		
		#checks if its barbed wire
		if get_cell_atlas_coords(local_to_map(get_local_mouse_position())) == barbed_wire_vector:
			for b in barbed_wire_list: #this is to check that the player is actually hovering over the wire
				if b.inside == true:
					self.set_cell(self.local_to_map(get_local_mouse_position()), 0, Vector2i(0, 0))
					b.inside = false #probably dont want this bit here, i just had a bug when i had it inside the barbed wire itself
					#the barbed wire is then turned to no mans land
		
		#checks if its the bunker
		if get_cell_atlas_coords(local_to_map(get_local_mouse_position())) == gun_post_vector:
			if bunker.inside == true and bunker.destroyed == false: #checks if arrow is inside
				bunker.blow_up()
				

###all of this is to deterim if the mouse is inside the right areas
func _on_english_trench_area_mouse_entered() -> void:
	if curent_area == 0:
		eng_inside = true
		Input.set_custom_mouse_cursor(custom_cursor_up)

func _on_english_trench_area_mouse_exited() -> void:
	eng_inside = false
	Input.set_custom_mouse_cursor(null)

func _on_german_trench_area_mouse_entered() -> void:
	if curent_area == 1:
		ger_inside = true
		Input.set_custom_mouse_cursor(custom_cursor_down)

func _on_german_trench_area_mouse_exited() -> void:
	ger_inside = false
	Input.set_custom_mouse_cursor(null)
