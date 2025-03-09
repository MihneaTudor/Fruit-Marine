extends Area2D

@export_file var level
@onready var location = get_parent().get_parent()
var inside: bool = false;

func _process(delta: float) -> void:
	if inside:
		go_to_level()
	
		
func go_to_level():
	print(location.name)
	if Input.is_action_just_pressed("shoot"):
		if (location.name=="Boss_Dragon_P1"):
			get_tree().change_scene_to_file("res://Scenes/Endless_game.tscn")
		if (location.name=="Musca_Fight"):
			get_tree().change_scene_to_file("res://Scenes/Endless_Parry.tscn")
		if (location.name=="game"):
			get_tree().change_scene_to_file("res://Scenes/Endless_Musca.tscn")
		if (location.name=="Boss_Parry"):
			get_tree().change_scene_to_file("res://Scenes/Endless_Dragon.tscn")
		


func _on_body_entered(body: Node2D) -> void:
	body.get_node("ButtonAnimation").visible = true
	inside = true
