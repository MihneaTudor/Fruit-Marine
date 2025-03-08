extends Area2D

var light = load("res://Scenes/White Circle.tscn")

var offset
var current_health
@export var max_health = 100

func _ready() -> void:
	var parent = get_parent()  # Get the parent node
	offset = parent.difficulty_offset
	max_health=max_health* offset
	current_health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	#var a = tree.instantiate()
	#a.global_transform *= 3
	#self.add_child(Light)
	Light.global_position= pos
	#owner.add_child(a)
	#a.global_position=pos
