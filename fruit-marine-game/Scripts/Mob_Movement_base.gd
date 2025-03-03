extends RigidBody2D

const Speed=30
var direction=1
@onready var ray_cast_up= $RayCastUp
@onready var ray_cast_down=$RayCastDown

func _process(delta: float) -> void:
	if ray_cast_down.is_colliding():
		direction = -1
	if ray_cast_up.is_colliding():
		direction = 1
		
	linear_velocity.y = direction * Speed
