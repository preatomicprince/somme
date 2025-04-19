class_name Unit extends Node2D

enum UNIT_TYPE {
	Soldier = 0,
	Officer = 1,
	Medic = 2,
	Artillery = 3,
	Machinegun = 4
}

var npc_state: NPC_State

var start_pos: Vector2 

@export var army: Game.ARMIES = 0
@export var unit_type: UNIT_TYPE = 0


var max_moves: int = 5 # Max moves per turn
var moves: int = max_moves # moves remaining this turn

var max_health: int = 100
var health: int = max_health

# Courage used to determine if units retreat
var max_courage: int = 10
var courage: int = max_courage

# List of units than this unit can see. Updated each move
var visible_units: Array = []

func _ready() -> void:
	var start_pos: Vector2 = global_position
	
	# Create state machine
	npc_state = preload("res://Unit/npc_state.tscn").instantiate()
	add_child(npc_state)
	

func next_turn() -> void:
	moves = max_moves
	
func next_move() -> void:
	look_for_units()
	
func reset() -> void:
	moves = max_moves
	health = max_health
	global_position = start_pos
	
func look_for_units() -> Array:
	"""
	Returns an array of all units in line of sight in form [army(0 or 1), unit_ind]
	"""
	return []
	
