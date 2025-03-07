extends Area2D

@export var speed = 500

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"): 
		body.take_damage(1)
		self.queue_free()
	
func _on_area_entered(area: Node2D) -> void:
	if area.has_method("take_damage"): 
		area.take_damage(1)
		self.queue_free()
