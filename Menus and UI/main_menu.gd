extends Node2D

#@onready var basic_training = preload("res://Menus and UI/main_menu.tscn")
@onready var main_game = "res://Game/game.tscn"
@onready var credits = "res://Menus and UI/credits.tscn"

	

func _on_training_button_up() -> void:
	
	get_tree().change_scene_to_file(main_game)


func _on_credits_button_up() -> void:
	get_tree().change_scene_to_file(credits)


func _on_training_button_down() -> void:
	$click.play()


func _on_credits_button_down() -> void:
	$click.play()
