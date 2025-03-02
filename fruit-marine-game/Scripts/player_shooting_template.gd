@export var Bullet: PackedScene

var scene = load("res://Scenes/glont_template.tscn")

func shoot():
	if not Bullet:
		return;
	var b = scene.instantiate()
	b.global_transform = Marker2D.global_transform
	print("2")
	
func _physics_process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()
	
