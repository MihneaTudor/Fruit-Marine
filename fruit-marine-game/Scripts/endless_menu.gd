extends Node2D

@export_file var menu

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Menu") and not visible:
		print("Menu Opened")
		visible = true
		get_tree().paused = true
		
	elif Input.is_action_just_pressed("Menu") and visible:
		print("Menu Closed")
		visible = false
		get_tree().paused = false
		
		
	if Input.is_action_just_pressed("Down") and visible:
		#menu
		get_tree().paused = false
		print("Ca baietii inapoi in meniu")
		get_tree().change_scene_to_file(menu)
