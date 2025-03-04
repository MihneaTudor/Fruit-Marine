extends RigidBody2D

var scene = load("res://Scenes/boss_ammo.tscn")
const Speed = 30
var direction = 1
var max_health = 10
@onready var ray_cast_up= $RayCastUp
@onready var ray_cast_down=$RayCastDown
var current_health: int
var t1 = randi() % 3

func _process(delta: float) -> void:
	if ray_cast_down.is_colliding():
		direction = -1
	if ray_cast_up.is_colliding():
		direction = 1
	if $Timer.is_stopped() and current_health>=(max_health/2):
		shoot()	
	else: if $Timer.is_stopped() and current_health<max_health/2:
		shoot1()
		shoot2()
		shoot3()
		$Timer.start()
	linear_velocity.y = direction * Speed


func _ready():
	current_health = max_health 
	var t1 = randi() % 3
	#health_changed.emit(current_health)  # Emit signal for UI
	
func shoot():
	print(current_health)
	if (t1==0):
		shoot1()
		shoot2()
	if (t1==1):
		shoot2()
		shoot3()
	if (t1==2):
		shoot1()
		shoot3()
	t1=randi()%3
	$Timer.start()
func shoot1():
	var b = scene.instantiate()
	owner.add_child(b)
	b.global_transform = $Marker2D.global_transform

func shoot2():	
	var b = scene.instantiate()
	owner.add_child(b)
	b.global_transform = $Marker2D2.global_transform

func shoot3():	
	var b = scene.instantiate()
	owner.add_child(b)
	b.global_transform = $Marker2D3.global_transform

func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)  # Prevent negative HP
	#health_changed.emit(current_health)
	if current_health == 0:
		print("A CRAPAT VITA")
