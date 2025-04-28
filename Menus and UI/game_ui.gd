extends CanvasLayer

###these are to change the behaviour of the aim buttons
@onready var aim_but_disabled : TextureButton = $"bottom/button container/context button"
@onready var aim_but_abled : TextureButton = $"bottom/button container/context button2"

###these are to change the behaviour of the stance buttons
@onready var stance_but_disabled : TextureButton = $"bottom/button container/stance button"
@onready var stance_but_abled : TextureButton = $"bottom/button container/stance button2"


func _on_context_button_pressed() -> void:
	"""
	this is where youll want to call the function for aiming your weapon
	"""
	toggle_aim_buts()

func _on_context_button_2_pressed() -> void:
	"""
	this is where youll want to stop the aiming 
	"""
	toggle_aim_buts()

func _on_stance_button_pressed() -> void:
	"""
	this is where we want the function for changing the stance of the character to prone
	"""
	toggle_stance_buts()

func _on_stance_button_2_pressed() -> void:
	"""
	this is where we want the function for changing the stance of the character to standing up
	"""
	toggle_stance_buts()

func toggle_aim_buts() -> void:
	"""
	created this function to switch the different context buttons on and off
	so after you fire you can call this function and it will switch em
	as well as in the button presses
	"""
	if aim_but_disabled.visible == true:
		aim_but_disabled.visible = false
		aim_but_abled.visible = true
		return
	else:
		aim_but_disabled.visible = true
		aim_but_abled.visible = false
		return

func toggle_stance_buts() -> void:
	"""
	doesnt really need to be a function, its just for the symetry really
	maybe itll be useful
	"""
	if stance_but_disabled.visible == true:
		stance_but_disabled.visible = false
		stance_but_abled.visible = true
		return
	else:
		stance_but_disabled.visible = true
		stance_but_abled.visible = false
		return
