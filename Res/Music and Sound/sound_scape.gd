extends Node2D

var random : RandomNumberGenerator = RandomNumberGenerator.new()

func _on_firefight_start_timeout() -> void:
	$firefight.play()
	$"firefight start".wait_time = random.randi_range(15, 35)
	$"firefight start".start()


func _on_biplane_start_timeout() -> void:
	$biplane.play()
