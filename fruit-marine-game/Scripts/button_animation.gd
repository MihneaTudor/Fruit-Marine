extends AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale.x = abs(scale.x) * sign($"..".position.x)
