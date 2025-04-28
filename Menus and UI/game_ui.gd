extends CanvasLayer

###these are to change the behaviour of the aim buttons
@onready var aim_but_disabled : TextureButton = $"bottom/button container/context button"
@onready var aim_but_abled : TextureButton = $"bottom/button container/context button2"

###these are to change the behaviour of the stance buttons
@onready var stance_but_disabled : TextureButton = $"bottom/button container/stance button"
@onready var stance_but_abled : TextureButton = $"bottom/button container/stance button2"

@onready var mid_layer : GridContainer = $mid
@onready var background : ColorRect = $"background colour"

var show_colour : bool = false #use this to steadily cover up the background upon a death

func _process(delta: float) -> void:
	if show_colour == true:
		background.modulate.a += 0.1
	else:
		background.modulate.a -= 0.1
	
func on_death_ui() -> void:
	"""
	toggle this to pull up the choose character selection
	"""
	mid_layer.visible = true
	show_colour = true

func on_char_selected() -> void:
	"""
	called within the character select buttons, in the mid grid section
	we'll want to feed the info from that button like the characters name into the 
	new unit maybe?
	"""
	mid_layer.visible = false
	show_colour = false

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
