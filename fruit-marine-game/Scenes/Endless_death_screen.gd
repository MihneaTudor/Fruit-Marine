extends Control

@onready var location = get_parent()
var ok=1

func _process(delta: float) -> void:
	print(self.modulate.a)
	if self.modulate.a >= 0.99 and ok==1:
		$Teleport.start()
		ok=0
	if $Teleport.is_stopped() and ok==0:
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		
