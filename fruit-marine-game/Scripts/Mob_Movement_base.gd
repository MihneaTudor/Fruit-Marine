extends RigidBody2D

var scene = load("res://Scenes/boss_ammo.tscn")
const Speed = 30
var direction = 1
var max_health = 1
@onready var ray_cast_up= $RayCastUp
@onready var ray_cast_down=$RayCastDown
var current_health: int

func _process(delta: float) -> void:
	if ray_cast_down.is_colliding():
		direction = -1
	if ray_cast_up.is_colliding():
		direction = 1
	if  $Timer.is_stopped():
		shoot()	
	linear_velocity.y = direction * Speed


func _ready():
	current_health = max_health 
	#health_changed.emit(current_health)  # Emit signal for UI
	
	
func shoot():
	var b = scene.instantiate()
	owner.add_child(b)
	b.global_transform = $Marker2D.global_transform
	$Timer.start()

func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)  # Prevent negative HP
	#health_changed.emit(current_health)
	if current_health == 0:
		print("DA SA MOARA MAMA")
