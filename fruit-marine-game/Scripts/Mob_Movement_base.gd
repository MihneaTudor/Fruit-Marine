extends CharacterBody2D

var scene = load("res://Scenes/boss_ammo.tscn")
const Speed = 30
var gravity = ProjectSettings.get("physics/2d/default_gravity")  # Get Godot's gravity
var direction = 1
var max_health = 10
var current_health: int
var layer=1
var timer
var Jump_rand
var t1
var can_drop_to_hell = false
var layer2

func _process(delta: float) -> void:
	if $Timer.is_stopped() and current_health>=(max_health/2):
		shoot()	
	else: if $Timer.is_stopped() and current_health<max_health/2:
		shoot1()
		shoot2()
		shoot3()
		$Timer.start()
	
				
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor() and can_drop_to_hell:
		drop()
		can_drop_to_hell=false
	if $Timer2.is_stopped():
		var layering = randi() % 2 + 1
		layer2 = (layering + layer) % 3
		print(layer2)
		if layer2>layer and is_on_floor():
			jump(700+(layer2-layer-1)*220)
			layer=layer2
		if layer2<layer and is_on_floor():
			drop()
			layer-=1
			if (layer2<layer):
				can_drop_to_hell=true
				layer-=1
			
		$Timer2.start()
	move_and_slide()
	
func _ready():
	current_health = max_health 
	var t1 = randi() % 3
	layer = 1
	$Timer2.start()
	#health_changed.emit(current_health)  # Emit signal for UI
	
func shoot():
	if not is_on_floor():
		return;
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
		
func drop():
	position.y += 1
	
func jump(jump_velocity: float):
	velocity.y=-jump_velocity;
