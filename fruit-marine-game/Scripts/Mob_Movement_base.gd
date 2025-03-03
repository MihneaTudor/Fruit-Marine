extends RigidBody2D

var scene = load("res://Scenes/glont_template.tscn")
const Speed=30
var direction=1
@onready var ray_cast_up= $RayCastUp
@onready var ray_cast_down=$RayCastDown

func _process(delta: float) -> void:
	if ray_cast_down.is_colliding():
		direction = -1
	if ray_cast_up.is_colliding():
		direction = 1
	if  $Timer.is_stopped():
		shoot()	
	linear_velocity.y = direction * Speed

func shoot():
	var b = scene.instantiate()
	owner.add_child(b)
	b.global_transform = $Marker2D.global_transform
	$Timer.start()
