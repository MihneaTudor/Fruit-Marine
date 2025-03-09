extends Node2D

@export_file var campaign
@export_file var endless

func _ready() -> void:
	Offset.set_counter(1)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Space"):
		#Campaign
		get_tree().change_scene_to_file(campaign)
	if Input.is_action_just_pressed("Down"):
		#Endless
		get_tree().change_scene_to_file(endless)
