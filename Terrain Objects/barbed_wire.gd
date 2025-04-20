extends Sprite2D

var cut : bool = false #this shows whether the barbed wire has been cut, believe it or not.

func cut_wire() -> void:
	"""
	Can be called to make barbed wire accessible 
	"""
	$".".frame = 1
	$BarbedWire.frame = 1
	cut = true
