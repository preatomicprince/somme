extends Sprite2D

@export var tree_ind : int = 0 # Index for tree frame 

func _ready() -> void:
	"""
	This just sets the tree frame
	"""
	$".".frame = tree_ind
	$Trees.frame = tree_ind
