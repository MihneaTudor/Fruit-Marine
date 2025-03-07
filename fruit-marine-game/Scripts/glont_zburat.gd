extends Area2D

@export var speed = 500
@export var damage = 1

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.has_method("take_damage"): 
		body.take_damage(damage)
		self.queue_free()


func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.has_method("take_damage"): 
		area.take_damage(damage)
		self.queue_free()
