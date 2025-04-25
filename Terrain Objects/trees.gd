class_name Trees extends Sprite2D

@export var tree_ind : int = 0 # Index for tree frame 

func _ready() -> void:
	"""
	This just sets the tree frame
	"""
	self.modulate = Color(0.45, 0.45, 0.45, 1.00)
	$".".frame = tree_ind
	$Trees.frame = tree_ind
