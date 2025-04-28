class_name Unit extends Node2D

@onready var dead_brit : Sprite2D = $DeadBrit
@onready var dead_german : Sprite2D = $DeadGerman
@onready var shadow : Sprite2D = $CharacterShadow
@onready var british_spritesheet : Sprite2D = $CrouchForward
@onready var german_spritesheet : Sprite2D = $GermanSheet
@onready var anim_play_eng : AnimationPlayer = $AnimationPlayerEnglish
@onready var anim_play_ger : AnimationPlayer = $AnimationPlayerGerman


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

enum STANCES {
	Standing = 0,
	Prone = 1
}

const SPEED = 240


var map: Map

var npc_state: NPC_State

var start_pos: Vector2 

@export var army: Game.ARMIES = 0
@export var unit_type: UNIT_TYPE = 0

var stance : STANCES = 0 #used later in animation to decide which animation to choose

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
		british_spritesheet.visible = true
		german_spritesheet.visible = false
	if army == 1:
		british_spritesheet.visible = false
		german_spritesheet.visible = true

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
		return
		
	if moves <= 0:
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

func get_angle(pos: Vector2) -> Vector2:
	"""
	Returns a normalised vector of a global position and the unit.
	Used to calculate trajectory of bullet. 
	"""
	var x_dist: float = pos.x - self.global_position.x 
	var y_dist: float = pos.y - self.global_position.y
	
	var vec_norm: float  = sqrt((x_dist*x_dist) + (y_dist*y_dist))
	
	return Vector2(x_dist/vec_norm, y_dist/vec_norm)
	
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
	if stance == STANCES.Standing:
		if direction == "down":
			anim_play_eng.play("walk forward")
		if direction == "left down":
			anim_play_eng.play("walk down left")
		if direction == "right down":
			anim_play_eng.play("walk down right")
		if direction == "up":
			anim_play_eng.play("walk up")
		if direction == "left up":
			anim_play_eng.play("walk up left")
		if direction == "right up":
			anim_play_eng.play("walk up right")
	
	if stance == STANCES.Prone:
		if direction == "down":
			anim_play_eng.play("prone down")
		if direction == "left down":
			anim_play_eng.play("prone down left")
		if direction == "right down":
			anim_play_eng.play("prone down right")
		if direction == "up":
			anim_play_eng.play("prone up")
		if direction == "left up":
			anim_play_eng.play("prone up left")
		if direction == "right up":
			anim_play_eng.play("prone up right")
	
func play_animation_shoot(direction: String):
	"""
	This plays the animation based on the direction its going
	"""
	if army == 0: #for the english
		if direction == "down":
			anim_play_eng.play("shoot down")
		if direction == "left down":
			anim_play_eng.play("shoot down left")
		if direction == "right down":
			anim_play_eng.play("shoot down right")
		if direction == "up":
			anim_play_eng.play("shoot up")
		if direction == "left up":
			anim_play_eng.play("shoot up left")
		if direction == "right up":
			anim_play_eng.play("shoot up right")
			
	if army == 1: #for the germans
		if direction == "down":
			anim_play_ger.play("shoot down")
		if direction == "left down":
			anim_play_ger.play("shoot down left")
		if direction == "right down":
			anim_play_ger.play("shoot down right")
		if direction == "up":
			anim_play_ger.play("shoot up")
		if direction == "left up":
			anim_play_ger.play("shoot up left")
		if direction == "right up":
			anim_play_ger.play("shoot up right")

func on_death():
	"""
	This shows the dead body upon death
	"""
	
	shadow.visible = false
	
	if army == 0:
		dead_brit.visible = true
		british_spritesheet.visible = false
		
	if army == 1:
		dead_german.visible = true
		german_spritesheet.visible = false
		

func change_stance():
	"""
	This function changes the stance of the unit
	"""
	
	if stance == STANCES.Standing:
		stance = STANCES.Prone
		return
		
	if stance == STANCES.Prone:
		stance = STANCES.Standing
		return
