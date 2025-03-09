extends Area2D

var light = load("res://Scenes/White Circle.tscn")
@export var tree = load("res://Scripts/tree.gd")

@export var max_health = 100
var current_health

func _ready() -> void:
	current_health = max_health

func _process(delta: float) -> void:
	if current_health == 0:
		die()

func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)  # Prevent negative HP
	$HitFlash.play("HitFlash")
	#health_changed.emit(current_health)

func die():
	var pos = global_position 
	$"../HP".queue_free()
	queue_free()

	var Light = light.instantiate()
	var a = tree.instantiate()
	a.global_transform *= 3
	$"..".add_child(Light)
	Light.global_position= pos
	$"..".add_child(a)
	a.global_position=pos + 250 * Vector2(0, 1)
