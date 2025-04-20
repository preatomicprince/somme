extends Sprite2D

@onready var outline : Sprite2D = $BarbedWireOutline
@onready var shadow : Sprite2D = $BarbedWire

var cut : bool = false #this shows whether the barbed wire has been cut, believe it or not.
var inside : bool = false #to work out if the thing

func cut_wire() -> void:
	"""
	Can be called to make barbed wire accessible 
	"""
	self.frame = 1
	shadow.frame = 1
	cut = true
	inside = false
	outline.visible = false

func _input(event: InputEvent) -> void:
	"""
	This will cut the wire if it hasnt been
	"""
	if event.is_action_pressed("left click"):
		if inside == true:
			cut_wire()

func _on_area_2d_mouse_shape_entered(shape_idx: int) -> void:
	"""
	when the mouse has entered itll show the highlight if it hasnt been cut
	"""
	print("inside")
	if cut == false:
		outline.visible = true
		inside = true

func _on_area_2d_mouse_shape_exited(shape_idx: int) -> void:
	outline.visible = false
	inside = false
