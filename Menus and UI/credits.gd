extends Node2D

@onready var main_menu = "res://Menus and UI/main_menu.tscn"

func _on_main_menu_button_button_up() -> void:
	get_tree().change_scene_to_file(main_menu)
