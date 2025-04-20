class_name Map extends TileMapLayer

@onready var barbed_wire_list : Array = [$BarbedWire, $BarbedWire2, $BarbedWire3, #list of barbed wire to toggle visiblitiy with
	$BarbedWire4, $BarbedWire5, $BarbedWire6, $BarbedWire7, $BarbedWire8, $BarbedWire9, 
	$BarbedWire10, $BarbedWire11, $BarbedWire12, $BarbedWire13, $BarbedWire14, 
	$BarbedWire15, $BarbedWire16, $BarbedWire17, $BarbedWire18, $BarbedWire19, 
	$BarbedWire20, $BarbedWire21, $BarbedWire22, $BarbedWire23, $BarbedWire24, 
	$BarbedWire25, $BarbedWire26, $BarbedWire27, $BarbedWire28, $BarbedWire29, 
	$BarbedWire30, $BarbedWire31] 
@onready var sandbag_list : Array = [$SandbagWall, $SandbagWall2, $SandbagWall3, $SandbagWall4] #list of sandbags to make visible ect
@onready var tree_list : Array = [$Trees, $Trees2, $Trees3, $Trees4, $Trees5, $Trees6, $Trees7, $Trees8] #list of trees to make visible/invisible
@onready var english_trench : Sprite2D = $"English trench"
@onready var german_trench: Sprite2D = $"German trench"
@onready var no_mans_land : Sprite2D = $"No Mans Land"

var barbed_wire_vector : Vector2i = Vector2i(0, 1)

func enter_no_mans_land() -> void:
	"""
	The point of this function is to reduce the alpha of non vital items whilst
	in no mans land
	"""
	english_trench.modulate = Color(0.45, 0.45, 0.45, 1.00)
	no_mans_land.modulate = Color(1.00, 1.00, 1.00, 1.00)
	
func enter_german_trench() -> void:
	"""
	This function makes no mans land and all its related detritus disapear.
	And increase the visibility of the german trench
	"""
	german_trench.modulate = Color(1.00, 1.00, 1.00, 1.00) 
	no_mans_land.visibe = false

func _input(event: InputEvent) -> void:
	"""
	This function changes the tile type underneath barbed wire you're cutting 
	"""
	
	if event.is_action_pressed("right click"):
		if get_cell_atlas_coords(local_to_map(get_local_mouse_position())) == barbed_wire_vector:
			for b in barbed_wire_list: #this is to check that the player is actually hovering over the wire
				if b.inside == true:
					self.set_cell(self.local_to_map(get_local_mouse_position()), 0, Vector2i(0, 0))
					#the barbed wire is then turned to no mans land


	
