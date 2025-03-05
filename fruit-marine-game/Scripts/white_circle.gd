extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", 30 * Vector2(1, 1), .75)
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 0), 2)
