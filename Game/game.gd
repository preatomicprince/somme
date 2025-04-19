class_name Game extends Node2D

var turn: int = 0
var character: int = 0 # Index for characters var
var time: float = 0.0 # If we want time of day to change with turns
var day: int = 0 # Incremented if current player character survives to next day

enum ARMIES{
	British = 0,
	German = 1
}

var map: Map

# Arrays containing all units, playable and unplayable
var british_units: Array = []
var german_units: Array = []
var units: Array[Array] = [british_units, german_units]

# List of playable characters filled with array containing [x, y] representing coordinates in units array
var characters: Array[Array] = []

func _ready() -> void:
	map = get_child(0)
	
	# Add units to units var
	var map_child_count: int = map.get_child_count()
	for i in range(0, map_child_count):
		var new_child: Node2D = map.get_child(i)
		if new_child is Unit:
			pass
	
