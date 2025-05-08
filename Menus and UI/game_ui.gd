extends CanvasLayer

var first_names : Array = [
	"William", "John", "George", "Thomas", "James", "Arthur", "Frederick", "Charles", "Albert", "Robert",
	"Joseph", "Alfred", "Henry", "Ernest", "Harry", "Harold", "Edward", "Walter", "Frank", "Herbert",
	"Richard", "Reginald", "Percy", "Leonard", "Samuel", "David", "Sidney", "Francis", "Stanley", "Fred",
	"Cecil", "Horace", "Cyril", "Wilfred", "Sydney", "Leslie", "Norman", "Edwin", "Victor", "Benjamin",
	"Tom", "Hector", "Jack", "Alexander", "Edgar", "Bertie", "Eric", "Philip", "Clifford", "Redvers",
	"Baden", "Bernard", "Daniel", "Donald", "Ralph", "Archibald", "Stephen", "Willie", "Peter",
	"Christopher", "Hugh", "Lewis", "Douglas", "Gilbert", "Ronald", "Isaac", "Hubert", "Maurice",
	"Clarence", "Lawrence", "Michael", "Edmund", "Patrick", "Percival", "Andrew", "Matthew", "Evan",
	"Wilfrid", "Bertram", "Louis", "Arnold", "Kenneth", "Gordon", "Ivor", "Gerald", "Abraham", "Geoffrey",
	"Owen", "Raymond", "Oliver", "Claude"
]

var secondary_names : Array = [
	"Allen", "Davis", "Jackson", "Morris", "Thompson", "Baker", "Edwards", "James", "Parker", "Turner",
	"Bennett", "Evans", "Johnson", "Phillips", "Walker", "Brown", "Green", "Jones", "Price", "Ward",
	"Carter", "Griffiths", "King", "Roberts", "Watson", "Clark", "Hall", "Lee", "Robinson", "White",
	"Clarke", "Harris", "Lewis", "Shaw", "Steele" ,"Williams", "Cook", "Harrison", "Martin", "Smith", "Wilson",
	"Cooper", "Hill", "Moore", "Taylor", "Wood", "Davies", "Hughes", "Morgan", "Thomas", "Wright"
]

var locations : Array = [
	"Bath", "Birmingham", "Blackburn", "Blackpool", "Bolton", "Bournemouth", "Bradford", "Brighton & Hove", 
	"Bristol", "Cambridge", "Canterbury", "Carlisle", "Chester", "Coventry", "Crewe", "Darlington", "Derby", 
	"Dewsbury", "Doncaster", "Dorset", "Eastbourne", "Exeter", "Frome", "Gloucester", "Grimsby", "Halifax", 
	"Hartlepool", "Hastings", "Hereford", "Hull", "Ilkley", "Ipswich", "Kingston", "Lancaster", "Leeds", 
	"Leicester", "Lincoln", "Liverpool", "Louth", "Lowestoft", "Ludlow", "Maidstone", "Manchester", "Margate", 
	"Medway", "Middlesbrough", "Milton Keynes", "Morecambe", "Newbury", "Newcastle", "Newport", "Nottingham", 
	"Oxford", "Peterborough", "Plymouth", "Poole", "Preston", "Reading", "Richmond", "Ripon", "Romford", 
	"Scarborough", "Sheffield", "Shrewsbury", "Southampton", "Southport", "Stafford", "Stoke-on-Trent", 
	"Stratford-on-Avon", "Sunderland", "Taunton", "Torquay", "Truro", "Tunbridge Wells", "Warrington", 
	"Waverley", "Wellington", "Westminster", "Wolverhampton", "Worcester", "York", "Beaconsfield", "Bury", 
	"Chesham", "Chichester", "Chorley", "Droitwich", "Dundee", "East Grinstead", "Ely", "Epping", "Farnham", 
	"Grantham", "Harrow", "Horsham", "King's Lynn", "Leicester", "Loughton", "Neston", "Otley"
]

var custom_cursor_target = load("res://Res/UI Elements/custom cursers4.png")
@onready var game_main = self.get_parent()

###for the control bar to check for victory
@onready var cont_bar : Control = $"topback/control bar"

###first time around
var first_time : bool = true ###if false it wont show any text, i just realised this wont work wioth the restart the way it is

###for the tutorial text
var tutorial_text = "[right]YOU MUST GO OVER THE TOP   ".format({})
###for the names
var cur_name : String = ""
@onready var name_text_display = $top/names

@onready var days_gone = $"top/days left"
var num_days : int = 1
var lives_lost : int = 0
#@onready var game_top = $".."

@onready var turn_text = $top/turn

###these are to change the behaviour of the aim buttons
@onready var aim_but_disabled : TextureButton = $"bottom/button container/context button"
@onready var aim_but_abled : TextureButton = $"bottom/button container/context button2"

###these are to change the behaviour of the stance buttons
@onready var stance_but_disabled : TextureButton = $"bottom/button container/stance button"
@onready var stance_but_abled : TextureButton = $"bottom/button container/stance button2"

@onready var char_select_list : Array = [$"mid/character select button", $"mid/character select button2"]

@onready var mid_layer : GridContainer = $mid
@onready var background : ColorRect = $"background colour"

@onready var mouse_click = $click

var show_colour : bool = false #use this to steadily cover up the background upon a death

func _process(delta: float) -> void:
	
	if first_time == true:
		$"tutorial holder/tut text".text = tutorial_text
	
	if show_colour == true:
		if background.modulate.a < 1:
			background.modulate.a += 0.1
	else:
		if background.modulate.a > 0:
			background.modulate.a -= 0.1
			
	if cont_bar.victory == true:
		on_victory()
	
func on_death_ui() -> void:
	"""
	toggle this to pull up the choose character selection
	"""
	mid_layer.visible = true
	show_colour = true
	$"mid/death text".text = "[center]{name} died April {date}th, 
	1917

	Whoes next to go over the top?".format({"name": name_text_display.text, "date": num_days+8})

func on_char_selected(to_display) -> void:
	"""
	called within the character select buttons, in the mid grid section
	we'll want to feed the info from that button like the characters name into the 
	new unit maybe?
	"""
	mouse_click.play()
	name_text_display.text = to_display
	num_days += 1
	days_gone.text = "[center]Day Number {day}".format({"day": num_days})
	mid_layer.visible = false
	show_colour = false
	for c in char_select_list:
		c.new_info()

func on_victory() -> void:
	"""
	this function is called when we have a victory
	"""
	$"victory stats/days taken".text = "[center]Days taken: {num_days}".format({"num_days": num_days})
	$"victory stats/lives lost".text = "[center]Lives lost: {num_lives}".format({"num_lives": lives_lost})
	$"victory stats".visible = true
	show_colour = true

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
	stance_but_disabled.visible = true
	stance_but_abled.visible = false
	if game_main.pc_unit != null:
		game_main.pc_unit.stance = 0
		
	mouse_click.play()
	if aim_but_disabled.visible == true:
		game_main.pc_unit.action_mode = Unit.ACTION_MODE.Attack
		Input.set_custom_mouse_cursor(custom_cursor_target)
		aim_but_disabled.visible = false
		aim_but_abled.visible = true
		return
	else:
		game_main.pc_unit.action_mode = Unit.ACTION_MODE.Move
		Input.set_custom_mouse_cursor(null)
		aim_but_disabled.visible = true
		aim_but_abled.visible = false
		return

func toggle_stance_buts() -> void:
	"""
	doesnt really need to be a function, its just for the symetry really
	maybe itll be useful
	"""
	mouse_click.play()
	if stance_but_disabled.visible == true:
		stance_but_disabled.visible = false
		stance_but_abled.visible = true
		if game_main.pc_unit != null:
			game_main.pc_unit.stance = 1
		return
	else:
		stance_but_disabled.visible = true
		stance_but_abled.visible = false
		if game_main.pc_unit != null:
			game_main.pc_unit.stance = 0
		return


func _on_restart_pressed() -> void:
	
	get_tree().reload_current_scene()


func _on_context_button_mouse_entered() -> void:
	$"bottom/for spaceing/button info text shoot".visible = true

func _on_context_button_mouse_exited() -> void:
	$"bottom/for spaceing/button info text shoot".visible = false


func _on_context_button_2_mouse_entered() -> void:
	$"bottom/for spaceing/button info text shoot".visible = true


func _on_context_button_2_mouse_exited() -> void:
	$"bottom/for spaceing/button info text shoot".visible = false

func _on_stance_button_mouse_entered() -> void:
	$"bottom/for spaceing2/button info text prone".visible = true

func _on_stance_button_mouse_exited() -> void:
	$"bottom/for spaceing2/button info text prone".visible = false
