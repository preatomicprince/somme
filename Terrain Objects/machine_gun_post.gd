extends Sprite2D


var destroyed : bool = false #used to tell if the machine gun post can be destroyed or is still firing  
var inside : bool = false #used to work out if the mouse is inside the doorway of the trench

func blow_up() -> void:
	"""
	Right now this will just change the colour of the machine gun post,
	but we'll add special affects and stuff later, really tart it up
	"""
	self.modulate = Color(0.45, 0.45, 0.45, 1.00)
	destroyed = true
	print("here")


func _on_area_2d_mouse_shape_entered(shape_idx: int) -> void:
	inside = true

func _on_area_2d_mouse_shape_exited(shape_idx: int) -> void:
	inside = false
