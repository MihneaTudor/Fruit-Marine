extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(-3831.016, position.y), 5)
