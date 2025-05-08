class_name Barbed_Wire extends Node2D

@onready var outline : Sprite2D = $BarbedWireOutline
@onready var shadow : Sprite2D = $BarbedWire
@onready var cut_sound = $"cut wire sound"
@onready var map = self.get_parent()

var cut_cursor = load("res://Res/UI Elements/custom cursers2.png")

var cut : bool = false #this shows whether the barbed wire has been cut, believe it or not.
var inside : bool = false #to work out if the thing

func _ready() -> void:
	self.modulate = Color(0.45, 0.45, 0.45, 1.00)

func cut_wire() -> void:
	"""
	Can be called to make barbed wire accessible 
	"""
	cut_sound.play()
	self.frame = 1
	shadow.frame = 1
	cut = true
	#inside = false
	outline.visible = false
	Input.set_custom_mouse_cursor(null)
	
func reset() -> void:
	"""
	Resets wire to uncut state
	"""
	self.modulate = Color(0.45, 0.45, 0.45, 1.00)
	self.frame = 0
	shadow.frame = 0
	cut = false
	#inside = false
	outline.visible = true
	
func _input(event: InputEvent) -> void:
	"""
	This will cut the wire if it hasnt been
	"""
	if event.is_action_pressed("right click"):
		if inside == true:
			cut_wire()

func _on_area_2d_mouse_shape_entered(shape_idx: int) -> void:
	"""
	when the mouse has entered itll show the highlight if it hasnt been cut
	"""
	if map.game.pc_unit == null :
		return
	if map.game.pc_unit.action_mode != 2:
		if cut == false:
			Input.set_custom_mouse_cursor(cut_cursor)
			outline.visible = true
			inside = true

func _on_area_2d_mouse_shape_exited(shape_idx: int) -> void:
	if map.game.pc_unit == null :
		return
		
	if map.game.pc_unit.action_mode != 2:
		outline.visible = false
		inside = false
		Input.set_custom_mouse_cursor(null)
