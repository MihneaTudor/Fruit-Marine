extends Control

@onready var location = get_parent()
var ok=1

func _process(delta: float) -> void:
	print(self.modulate.a)
	if self.modulate.a >= 0.99 and ok==1:
		$Teleport.start()
		ok=0
	if $Teleport.is_stopped() and ok==0:
		if (location.name=="Boss_Dragon_P1"):
			get_tree().change_scene_to_file("res://Scenes/level_select_4.tscn")
		if (location.name=="Musca_Fight"):
			get_tree().change_scene_to_file("res://Scenes/level_select_2.tscn")
		if (location.name=="game"):
			get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
		if (location.name=="Boss_Parry"):
			get_tree().change_scene_to_file("res://Scenes/level_select_3.tscn")
		
