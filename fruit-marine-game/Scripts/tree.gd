extends Area2D

@export_file var level

var inside: bool = false;

func _process(delta: float) -> void:
	if inside:
		go_to_level()
		
func go_to_level():
	if Input.is_action_just_pressed("shoot"):
		Offset.increase_int()
		get_tree().change_scene_to_file(level)


func _on_body_entered(body: Node2D) -> void:
	body.get_node("ButtonAnimation").visible = true
	inside = true


func _on_body_exited(body: Node2D) -> void:
	body.get_node("ButtonAnimation").visible = false
	inside = false
