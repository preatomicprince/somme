class_name NPC_State extends Node2D

@onready var unit: Unit = get_parent()

var enemy_target = null


func _ready() -> void:
	if unit.army == Game.ARMIES.British:
		pass
			


func update() -> void:
	if unit.end_turn == true:
		return
	if unit.get_input == false:
		return
	
	enemy_target = _get_target()
		
	if unit.army == Game.ARMIES.British:
		if enemy_target == null:
			_update_move()
		else:
			var chance = randi()
			if chance > .3: # If has target, fire on them 70% of the time
				_update_attack()
			else:
				_update_move()
				
	if unit.army == Game.ARMIES.German:
		_update_attack()

func _update_move() -> void:
	pass
	
func _update_attack() -> void:
	if enemy_target == null:
		unit.get_input == false
		unit.end_turn == true
		return
	
	var target_pos = enemy_target.position
	unit.set_bullet(target_pos)
	
func _choose_mode() -> void:
	pass
	
func _get_target() -> Unit:
	"""
	Checks if any targets are in range and returns one at random.
	"""
	var unit_tile: Vector2i = unit.current_tile
	var range: int = 7
	var targets: Array = []
	for x in range(unit_tile.x - range, unit_tile.x + range):
		for y in range(unit_tile.y - range, unit_tile.y + range):
			if x < 0 or y < 0:
				continue
			var tile_id = unit.map.get_tile_id(Vector2(x, y))
			
			if unit.map.units[tile_id] != null:
				targets.append(unit.map.units[tile_id])
	if len(targets) == 0:
		return null
	
	return targets[randi_range(0, len(targets)-1)]
