extends Control

@onready var brit_bar = $"british bar"
var screen_size_x : int 
var cur_amount : int
var target_amount : int
var amount_for_german : int
var amount_for_bunker : int
var over_all_num_germans : int = 0 ###need to know this so we can divide the screen size up
var bar_speed : int = 10
var victory : bool = false ###used, checked inside the ui to see if theres a victory

func _ready() -> void:
	"""
	we get the width of the screen, half the width is for when you destroy the bunker
	the rest is divided up between the number of germans
	once the bar is filled, you win the game
	"""
	screen_size_x = get_viewport_rect().size.x
	
	amount_for_bunker = screen_size_x/2
	amount_for_german = screen_size_x/over_all_num_germans 

func _process(delta: float) -> void:
	if cur_amount <= target_amount:
		cur_amount += bar_speed
	
	brit_bar.size.x = cur_amount
	
	if brit_bar.size.x >= screen_size_x:
		victory = true

func bunker_dest():
	target_amount += amount_for_bunker

func german_killed():
	target_amount += amount_for_german
