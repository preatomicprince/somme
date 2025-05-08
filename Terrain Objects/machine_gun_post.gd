extends Sprite2D
#
@onready var par_map : TileMapLayer = self.get_parent()
@onready var smoke_collection : Array = [$smoke, $smoke2, $smoke3]
@onready var machine_gun_fire: Array = [$"machine gun fire",$"machine gun fire2"]
@onready var timer : Timer = $"fire timer"
@onready var machine_gun_sound = $"machine gun sound"
@onready var blow_up_sound = $"blow up"
@onready var rubble = $Rubble
@onready var map = self.get_parent()
var bomb_cursor = load("res://Res/UI Elements/custom cursers3.png")

var destroyed : bool = false #used to tell if the machine gun post can be destroyed or is still firing  
var inside : bool = false #used to work out if the mouse is inside the doorway of the trench



func blow_up() -> void:
	"""
	Right now this will just change the colour of the machine gun post,
	but we'll add special affects and stuff later, really tart it up
	"""
	blow_up_sound.play()
	for s in smoke_collection:
		s.emitting = true
	self.modulate = Color(0.45, 0.45, 0.45, 1.00)
	
	for i in map.game.german_units:
		if i.unit_type == Unit.UNIT_TYPE.Machinegun:
			i.on_death()
	destroyed = true
	rubble.visible = true
	par_map.game.game_ui.cont_bar.bunker_dest() ###used to add towards the victory
	Input.set_custom_mouse_cursor(null)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("emiting test"):
		fire_machine_guns()
		
func fire_machine_guns() -> void:
	"""
	right now this just sets the firing animation with its respective timer
	"""
	
	for m in machine_gun_fire:
		m.emitting = true
		m.get_child(0).emitting = true
	machine_gun_sound.play()
	timer.start()

func _on_area_2d_mouse_shape_entered(shape_idx: int) -> void:
	if map.game.pc_unit == null :
		return
	if destroyed == false and map.game.pc_unit.action_mode != 2:
		inside = true
		Input.set_custom_mouse_cursor(bomb_cursor)

func _on_area_2d_mouse_shape_exited(shape_idx: int) -> void:
	if map.game.pc_unit == null :
		return
	if destroyed == false and map.game.pc_unit.action_mode != 2:
		inside = false
		Input.set_custom_mouse_cursor(null)

func _on_fire_timer_timeout() -> void:
	for m in machine_gun_fire:
		m.emitting = false
		m.get_child(0).emitting = false
