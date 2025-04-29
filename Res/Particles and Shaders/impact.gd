extends CPUParticles2D

var hit_ground_colour : Color = Color(0.157, 0.118, 0.102, 1.0)
var blood_red : Color = Color(0.329, 0.0, 0.0, 1.0)
var sandbag_hit : Color = Color(0.486, 0.329, 0.173, 1.0)

var colour_show : Color

func _ready() -> void:
	"""
	give it one of the colours up above when creating it to change what it hits
	"""
	#self.color = colour_show
	pass
