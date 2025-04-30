class_name Unit extends Node2D

@onready var corpse = preload("res://Terrain Objects/corpse.tscn")

@onready var par_map : TileMapLayer = self.get_parent()
@onready var shadow : Sprite2D = $CharacterShadow
@onready var british_spritesheet : Sprite2D = $CrouchForward
@onready var german_spritesheet : Sprite2D = $GermanSheet
@onready var anim_play_eng : AnimationPlayer = $AnimationPlayerEnglish
@onready var anim_play_ger : AnimationPlayer = $AnimationPlayerGerman

var text_feedback_list : Array = ["[center]MISS".format({}), "[center]HIT".format({})]#a list of all the text to show the player when they hit or miss something

var dead: bool = false

var is_main_char : bool = false #determins if this is the character that is being controlled

enum UNIT_TYPE {
	Soldier = 0,
	Officer = 1,
	Medic = 2,
	Artillery = 3,
	Machinegun = 4
}

enum ACTION_MODE {
	None = 0,
	Move = 1,
	Attack = 2
}

enum STANCES {
	Standing = 0,
	Prone = 1
}

const SPEED = 440

var map: Map

var npc_state: NPC_State

var start_pos: Vector2 

@export var army: Game.ARMIES = 0
@export var unit_type: UNIT_TYPE = 0

var stance : STANCES = 0 #used later in animation to decide which animation to choose

var max_moves: int = 12 # Max moves per turn. Attempting to move further than this is invalid

var max_health: int = 100
var health: int = max_health

# Courage used to determine if units retreat
var max_courage: int = 10
var courage: int = max_courage

var current_tile: Vector2i

# List of units than this unit can see. Updated each move
var visible_units: Array = []

var move_queue: Array = []

var action_mode: ACTION_MODE = ACTION_MODE.Move # Are they walking or setting up to walk? or to shoot?

var get_input: bool = true # Set to false while already moving or shooting, reset at end of turn

var bullet_pos: Vector2 = Vector2(-1, -1) # Starts at player, moves angle*speed each step
var bullet_angle: Vector2 = Vector2(-1, -1) # Set by get_angle
const BULLET_SPEED: int = 50 # Defines how far the bullet travels each step before doing a collision check
var bullet_step: float = 0
const MAX_BULLET_STEP: float = 40 # Max number of steps before bullet times out, turn ends

var end_turn = false # Has finished moving or shooting

func set_start_pos(new_start_pos) -> void:
	if army == 1:
		action_mode == ACTION_MODE.Attack
	start_pos = new_start_pos
	global_position = new_start_pos
	
	current_tile = map.local_to_map(position)

	map.units[map.get_tile_id(current_tile)] = self
	
func _ready() -> void:
	if unit_type == UNIT_TYPE.Machinegun:
		visible = false
		
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
	get_input = true
	end_turn = false
	

func set_move_queue(path: Array) -> void:
	move_queue = path
	get_input = false
	if is_main_char: 
		for i in move_queue:
			par_map.path_line.add_point(par_map.map_to_local(i)-par_map.global_position)
			
		
	
func _handle_movement(delta) -> void:
	"""
	Moves unit when next action is movement.
	Called in _process.
	also chooses what animation to play
	"""
	# Skip in no movement
	if len(move_queue) == 0:
		end_turn = true
		par_map.path_line.clear_points()
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
		map.units[map.get_tile_id(current_tile)] = null
		current_tile = map.local_to_map(position)
		map.units[map.get_tile_id(current_tile)] = self
		move_queue.pop_front()
		
func rotate_arrow() -> void:
	if action_mode == ACTION_MODE.Move:
		$Arrow.visible = false
		return
	var offset = 80
	$Arrow.visible = true
	var angle_to_mouse = get_angle(get_global_mouse_position())
	$Arrow.rotation = angle_to_mouse.angle() + PI/2
	$Arrow.position.x = angle_to_mouse.x * offset
	$Arrow.position.y = angle_to_mouse.y * offset
	#print(angle_to_mouse)
			

func get_angle(pos: Vector2) -> Vector2:
	"""
	Returns a normalised vector of a global position and the unit.
	Used to calculate trajectory of bullet. 
	Also oops. .normalize and .get_angle_to methods already exist. 
	"""
	var x_dist: float = pos.x - self.global_position.x 
	var y_dist: float = pos.y - self.global_position.y
	
	var vec_norm: float  = sqrt((x_dist*x_dist) + (y_dist*y_dist))
	
	return Vector2(x_dist/vec_norm, y_dist/vec_norm)
	
func set_bullet(mouse_pos: Vector2) -> void:
	"""
	Sets up bullet angle and pos.
	Takes mouse pos from input.
	Also now plays the animation for shooting
	"""
	bullet_pos = self.position
	bullet_angle = self.get_angle(mouse_pos)
	bullet_step = 0
	get_input = false
	
	if bullet_angle[0] < 0.3 and bullet_angle[0] > -0.3: ###this is north or south
		if bullet_angle[1] > 0.0: ##this is south
			play_animation_shoot("down")
			return
		if bullet_angle[1] < 0.0: ###this is north
			play_animation_shoot("up")
			return
			
	if bullet_angle[0] >= 0.3: ###this is for right shots
		if bullet_angle[1] <= 0.0: ###right north
			play_animation_shoot("right up")
			return
		if bullet_angle[1] > 0.0:
			play_animation_shoot("right down")
			return ###right south
			
	if bullet_angle[0] <= -0.3: ###this is for left shots
		if bullet_angle[1] <= 0.0: ###left north
			play_animation_shoot("left up")
			return
		if bullet_angle[1] > 0.0:
			play_animation_shoot("left down") ###left south
			return
	
	
func _handle_attack(delta: float) -> void:
	if army == 1:
		print("sssjdjdjdjjdjdjjd")
	if bullet_step > MAX_BULLET_STEP:
		end_turn = true
		feed_back_show("miss")
		return
		
	if end_turn == true:
		return
	
	const obst_atlas_coords: Array = [Vector2i(2,0), Vector2i(3,0), Vector2i(3,1)]
	
	if unit_type == UNIT_TYPE.Machinegun:
		map.bunker.fire_machine_guns()
		
	while(bullet_step < MAX_BULLET_STEP):
		bullet_step += 1
		bullet_pos.x = bullet_pos.x + bullet_angle.x*BULLET_SPEED
		bullet_pos.y = bullet_pos.y + bullet_angle.y*BULLET_SPEED
		
		var bullet_tile: Vector2i = map.local_to_map(bullet_pos)
		var atlas_coord: Vector2i = map.get_cell_atlas_coords(bullet_tile)
		
		var bullet_tile_id = map.get_tile_id(bullet_tile)
		
		###somewhere around here put impact
		
		# Calculate if bullet hits obstacle
		if obst_atlas_coords.has(atlas_coord): # If bullet's path overlaps with an obstacle
			var hit_roll: float = randf()
			var odds: float = bullet_step/MAX_BULLET_STEP - 0.2 # -0.2 means decrease chance of hit by 10%
			
			if hit_roll < odds: # If obstacle hit
				var hit_pos = bullet_pos - position
				$impact.position = hit_pos
				$impact.color = $impact.hit_ground_colour
				$impact.emitting = true
				end_turn = true
				feed_back_show("miss")
				return
		
		# Calculate if bullet hits enemy
		var map_unit: Unit = map.units[bullet_tile_id]
		if  map_unit != null and map_unit != self:
			
			if map_unit.army != self.army: # No friendly fire :( 
				var hit_roll: float = randf()
				
				var odds: float = bullet_step/MAX_BULLET_STEP + 0.1 # +0.1 means increase chance of hit by 10%
				
				if hit_roll > odds:
					var hit_pos = bullet_pos - position
					$impact.position = hit_pos
					$impact.emitting = true
					$impact.color = $impact.blood_red
					end_turn = true
					if map_unit.unit_type == Unit.UNIT_TYPE.Machinegun:
						return
					map_unit.on_death()
					feed_back_show("hit")
					return
					
	end_turn = true
	return
	
	
func reset() -> void:
	is_main_char = false
	health = max_health
	global_position = start_pos
	self.z_index = 10
	british_spritesheet.use_parent_material = true
	
func look_for_units() -> Array:
	"""
	Returns an array of all units in line of sight in form [army(0 or 1), unit_ind]
	"""
	return []
	
func _process(delta: float) -> void:
	if get_input == true: # Skip if there hasn't been an input yet
		return
	if army == 1:
		action_mode = 2
	if action_mode == ACTION_MODE.Move:
		_handle_movement(delta)
	elif action_mode == ACTION_MODE.Attack:
		if army == 1:
			print("ccccccc")
		_handle_attack(delta)
	
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
	
	if dead:
		return
		
	dead = true
	par_map.game.game_ui.lives_lost += 1
	#print(self)
	shadow.visible = false
	var new_corpe = corpse.instantiate()
	
	if is_main_char == true:
		is_main_char = false
		map.game.reset()
		british_spritesheet.use_parent_material = false
		par_map.game.game_ui.on_death_ui()
		self.z_index = 10000
		#return
	
	if army == 0:
		#corpse
		new_corpe.army = 0
		par_map.add_child(new_corpe)
		new_corpe.position = self.position
		map.game.british_units.erase(self)
		map.units[map.get_tile_id(current_tile)] = null
		self.queue_free()
		
	if army == 1:
		par_map.game.game_ui.cont_bar.german_killed() ###used to add towards the victory
		new_corpe.army = 1
		if unit_type == Unit.UNIT_TYPE.Machinegun:
			new_corpe.visible = false
		par_map.add_child(new_corpe)
		new_corpe.position = self.position
		map.game.german_units.erase(self)
		map.units[map.get_tile_id(current_tile)] = null
		self.queue_free()
		
		

func _input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("emiting test"):
	#	if is_main_char == true:
	#		self.on_death()

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

func feed_back_show(happened)->void:
	$"feedback timer".start()###when this finishes it turns off the text
	
	$"tut text".visible = true
	
	if happened == "miss":
		$"tut text".text = text_feedback_list[0]
		return
	
	if happened == "hit":
		$"tut text".text = text_feedback_list[1]
		return


func _on_feedback_timer_timeout() -> void:
	$"tut text".visible = false
