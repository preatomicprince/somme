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
