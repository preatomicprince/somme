extends Node2D

@onready var main_menu = "res://Menus and UI/main_menu.tscn"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_tree().quit() ###to exit the game

func _on_main_menu_button_button_up() -> void:
	get_tree().change_scene_to_file(main_menu)


func _on_main_menu_button_button_down() -> void:
	$click.play()
