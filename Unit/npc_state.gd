class_name NPC_State extends Node2D

@onready var unit: Unit = get_parent()

var enemy_target = null

var rng: RandomNumberGenerator


func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if unit.army == Game.ARMIES.British:
		pass
	
			


func update() -> void:
	randomize()
	enemy_target = null
	if unit.end_turn == true:
		return
	if unit.get_input == false:
		return
	
	enemy_target = _get_target()
	print("et", enemy_target)
		
	if unit.army == Game.ARMIES.British:
		if enemy_target == null:
			unit.action_mode = Unit.ACTION_MODE.Move
			_update_move()
		else:
			var chance = randi()
			if chance > .3: # If has target, fire on them 70% of the time
				unit.action_mode = Unit.ACTION_MODE.Attack
				_update_attack()
			else:
				unit.action_mode = Unit.ACTION_MODE.Move
				_update_move()
				
	else:
		_update_attack()

func _update_move() -> void:
	var x_offset = randi_range(1, 3)
	var y_offset = randi_range(-2, 2)
	
	var next_tile = unit.map.local_to_map(unit.global_position)

	next_tile.x += x_offset
	next_tile.y += y_offset
	
	var new_path: Array = unit.map.generate_path(unit.map.local_to_map(unit.global_position), next_tile)
	new_path.pop_front() # Removes first tile that unit is already stood on
	if len(new_path) <= unit.max_moves: # Ensures can only move set distance
		unit.set_move_queue(new_path)
		unit.get_input = false
	
	
func _update_attack() -> void:
	if enemy_target == null:
		unit.get_input == false
		unit.end_turn == true
		return
	
	var target_pos = enemy_target.global_position
	unit.set_bullet(target_pos)
	unit.get_input == false
	unit.end_turn == true
	return
	

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
				if unit.map.units[tile_id].army != unit.army:
					targets.append(unit.map.units[tile_id])
	if len(targets) == 0:
		return null
	
	var target = targets[rng.randi_range(0, len(targets)-1)]

	return target
