extends Area2D

var light = load("res://Scenes/White Circle.tscn")

@export var max_health = 100
var offset
var current_health

func _ready() -> void:
	current_health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
