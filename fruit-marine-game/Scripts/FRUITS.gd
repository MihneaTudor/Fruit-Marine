extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = $"../playerLevelSelect/Camera2D".global_position + Vector2(-40, 176)
