class_name Unit extends Node2D

enum UNIT_TYPE {
	Soldier = 0,
	Officer = 1,
	Medic = 2,
	Artillery = 3,
	Machinegun = 4
}

enum ACTION {
	None = 0,
	Move = 1,
	Attack = 2
}

const SPEED = 200


var map: Map

var npc_state: NPC_State

var start_pos: Vector2 

@export var army: Game.ARMIES = 0
@export var unit_type: UNIT_TYPE = 0


var max_moves: int = 50 # Max moves per turn
var moves: int = max_moves # moves remaining this turn

var max_health: int = 100
var health: int = max_health

# Courage used to determine if units retreat
var max_courage: int = 10
var courage: int = max_courage

# List of units than this unit can see. Updated each move
var visible_units: Array = []

var move_queue: Array = []

func set_start_pos(new_start_pos) -> void:
	start_pos = new_start_pos
	global_position = new_start_pos
	
func _ready() -> void:
	map = get_parent()
	
	# Create state machine
	npc_state = preload("res://Unit/npc_state.tscn").instantiate()
	add_child(npc_state)
	
	decide_animation()
	

func decide_animation():
	"""
	this chooses the model based on wheather its german or english
	called on ready
	"""
	if army == 0:
		$CrouchForward.visible = true
		$GermanSheet.visible = false
	if army == 1:
		$CrouchForward.visible = false
		$GermanSheet.visible = true

func next_turn() -> void:
	moves = max_moves

func set_move_queue(path: Array) -> void:
	move_queue = path
	
func _handle_movement(delta) -> void:
	"""
	Moves unit when next action is movement.
	Called in _process.
	also chooses what animation to play
	"""
	# Skip in no movement
	if len(move_queue) == 0:
		print("1")
		return
		
	if moves <= 0:
		print("2")
		return
		
	var next_move_pos = map.map_to_local(move_queue[0])
	
	###this is for down
	if next_move_pos[1] > self.global_position[1] and next_move_pos[0] == self.global_position[0]:
		self.play_animation_walk("down")
	###this is for left down
	if next_move_pos[1] > self.global_position[1] and next_move_pos[0] < self.global_position[0]:
		self.play_animation_walk("left down")
	###this is for right down
	if next_move_pos[1] > self.global_position[1] and next_move_pos[0] > self.global_position[0]:
		self.play_animation_walk("right down")
	###this is for walking up
	if next_move_pos[1] < self.global_position[1] and next_move_pos[0] == self.global_position[0]:
		self.play_animation_walk("up")
	###this is for walking up left
	if next_move_pos[1] < self.global_position[1] and next_move_pos[0] < self.global_position[0]:
		self.play_animation_walk("left up")
		
	if next_move_pos[1] < self.global_position[1] and next_move_pos[0] > self.global_position[0]:
		self.play_animation_walk("right up")
		
	self.global_position = global_position.move_toward(next_move_pos, SPEED*delta)
	
	if global_position == next_move_pos:
		move_queue.pop_front()
		moves -= 1
	
func reset() -> void:
	moves = max_moves
	health = max_health
	global_position = start_pos
	
func look_for_units() -> Array:
	"""
	Returns an array of all units in line of sight in form [army(0 or 1), unit_ind]
	"""
	return []
	
func _process(delta: float) -> void:
	_handle_movement(delta)
	
func play_animation_walk(direction: String):
	"""
	This plays the animation based on the direction its going
	"""
	if direction == "down":
		$AnimationPlayerEnglish.play("walk forward")
	if direction == "left down":
		$AnimationPlayerEnglish.play("walk down left")
	if direction == "right down":
		$AnimationPlayerEnglish.play("walk down right")
	if direction == "up":
		$AnimationPlayerEnglish.play("walk up")
	if direction == "left up":
		$AnimationPlayerEnglish.play("walk up left")
	if direction == "right up":
		$AnimationPlayerEnglish.play("walk up right")
	
func play_animation_shoot(direction: String):
	"""
	This plays the animation based on the direction its going
	"""
	if army == 0: #for the english
		if direction == "down":
			$AnimationPlayerEnglish.play("shoot down")
		if direction == "left down":
			$AnimationPlayerEnglish.play("shoot down left")
		if direction == "right down":
			$AnimationPlayerEnglish.play("shoot down right")
		if direction == "up":
			$AnimationPlayerEnglish.play("shoot up")
		if direction == "left up":
			$AnimationPlayerEnglish.play("shoot up left")
		if direction == "right up":
			$AnimationPlayerEnglish.play("shoot up right")
			
	if army == 1: #for the germans
		if direction == "down":
			$AnimationPlayerGerman.play("shoot down")
		if direction == "left down":
			$AnimationPlayerGerman.play("shoot down left")
		if direction == "right down":
			$AnimationPlayerGerman.play("shoot down right")
		if direction == "up":
			$AnimationPlayerGerman.play("shoot up")
		if direction == "left up":
			$AnimationPlayerGerman.play("shoot up left")
		if direction == "right up":
			$AnimationPlayerGerman.play("shoot up right")
