extends TextureButton

@onready var main_ui_file : CanvasLayer = $"../.."

@export var ang : int = -5 #this is just to give the buttons some angled flavour
 
var random : RandomNumberGenerator = RandomNumberGenerator.new()
var age : int = 18

var text_to_save : String = "pass"

func _ready() -> void:
	#self.rotation = ang
	new_info()

func new_info() -> void:
	var new_f_name = main_ui_file.first_names[random.randi_range(0, len(main_ui_file.first_names)-1)]
	var new_s_name = main_ui_file.secondary_names[random.randi_range(0, len(main_ui_file.secondary_names)-1)]
	age = random.randi_range(18, 28)
	var new_loc = main_ui_file.locations[random.randi_range(0, len(main_ui_file.locations)-1)]
	
	text_to_save = "[center]NAME: {fir} {sec}
	
	AGE: {age}
	
	FROM: {loc}[center]".format({"fir": new_f_name, "sec": new_s_name, "age": age, "loc": new_loc})
	$GridContainer/name.text = text_to_save
	
	text_to_save = "[center]{fir} {sec}, {age}, from {loc}[center]".format({"fir": new_f_name, "sec": new_s_name, "age": age, "loc": new_loc})

func _on_pressed() -> void:
	"""
	Put the code here for the choosing the new character
	"""
	main_ui_file.on_char_selected(text_to_save)
