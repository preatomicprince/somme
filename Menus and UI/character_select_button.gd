extends TextureButton

@export var ang : int = -5 #this is just to give the buttons some angled flavour

func _ready() -> void:
	#self.rotation = ang
	pass

func _on_pressed() -> void:
	"""
	Put the code here for the choosing the new character
	"""
	print("here")
