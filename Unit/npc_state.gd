class_name NPC_State extends Node2D

@onready var unit = get_parent()

var UNIT_TYPE = Unit.UNIT_TYPE

enum NPC_STATES {
	Idle = 0,
	Alert = 1,
	Advance = 2,
	Attack = 3,
	Retreat = 4
}

var state: NPC_STATES = 0

func _ready() -> void:
	match unit.unit_type:
		UNIT_TYPE.Soldier:
			state = NPC_STATES.Advance
		UNIT_TYPE.Officer:
			state = NPC_STATES.Alert
		UNIT_TYPE.Medic:
			state = NPC_STATES.Advance
		UNIT_TYPE.Artillery:
			state = NPC_STATES.Alert
		UNIT_TYPE.Machinegun:
			state = NPC_STATES.Alert
			
func update_state() -> void:
	"""
	Called at end of each move to decide next move.
	"""
	match unit.unit_type:
		UNIT_TYPE.Soldier:
			update_soldier()
	
func update_soldier() -> void:
	match state:
		NPC_STATES.Advance:
			pass
			
