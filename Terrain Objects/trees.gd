class_name Trees extends Node2D

@export var tree_ind : int = 0 # Index for tree frame 

func _ready() -> void:
	"""
	This just sets the tree frame
	"""
	self.modulate = Color(0.45, 0.45, 0.45, 1.00)
	$tree_sprite.frame = tree_ind
	$shadow.frame = tree_ind
