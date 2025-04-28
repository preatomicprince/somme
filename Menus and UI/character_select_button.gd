extends TextureButton

@onready var main_ui_file : CanvasLayer = $"../.."

@export var ang : int = -5 #this is just to give the buttons some angled flavour
 

func _ready() -> void:
	#self.rotation = ang
	pass

func _on_pressed() -> void:
	"""
	Put the code here for the choosing the new character
	"""
	main_ui_file.on_char_selected()
