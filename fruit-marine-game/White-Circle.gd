extends Node2D

@export var speed: float = 500.0  # How fast the circle expands
@export var max_size: float = 2000.0  # When to remove the circle
@export var fade_out: bool = true  # Enable fading effect

var radius: float = 10.0  # Initial radius

func _process(delta):
	radius += speed * delta  # Expand the circle
	queue_redraw()  # Redraw the scene

	if radius > max_size:
		queue_free()  # Remove itself when too large

func _draw():
	var alpha = 1.0 - (radius / max_size) if fade_out else 1.0
	var color = Color(1, 1, 1, alpha)  # White with fading
	draw_circle(Vector2.ZERO, radius, color)
