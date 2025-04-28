extends Node2D

@onready var brit_sheet : Sprite2D = $DeadBrit
@onready var german_sheet : Sprite2D = $DeadGerman

@export var army: Game.ARMIES = 0

var random_ind : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	choose_spritesheet()
	
func choose_spritesheet() -> void:
	if army == Game.ARMIES.British:
		$DeadBrit.visible = true
		$DeadGerman. visible = false
		brit_sheet.frame = random_ind.randi_range(0, 3)
		
	if army == Game.ARMIES.German:
		$DeadBrit.visible = false
		$DeadGerman.visible = true
		german_sheet.frame = random_ind.randi_range(0, 3)
