extends Area2D

@export var speed = 500
@export var damage = 1

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"): 
		body.take_damage(damage)
		self.queue_free()
