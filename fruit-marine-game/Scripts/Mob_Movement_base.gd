extends CharacterBody2D

var tree = load("res://Scenes/Tree.tscn")

var bullet = load("res://Scenes/boss_ammo.tscn")
var bullet_big = load("res://Scenes/boss_ammo_big.tscn")
var bullet_parry = load("res://Scenes/boss_ammo_parry.tscn")

var light = load("res://Scenes/White Circle.tscn")

const Speed = 30
var gravity = ProjectSettings.get("physics/2d/default_gravity")  # Get Godot's gravity
var direction = 1
var max_health = 10
var current_health: float
var layer=1
var timer
var Jump_rand
var t1
var can_drop_to_hell = false
var can_shoot = true
var is_stageered = false
var already_staggered = false
var layer2
var bullet_counter = 0
var dead = false

func _process(delta: float) -> void:
	if dead:
		$AnimatedSprite2D.play("Stagger")
		if $Timer_Outro.is_stopped():
			die()
		return
	
	if $StaggerTime.is_stopped() and is_stageered:
		is_stageered = false
		$AnimatedSprite2D.play("idle")
	if not $Timer_Intro.is_stopped():
		if $Timer_Intro.time_left == 0.75:
			$Timer.start()
			can_shoot=true
		return
	if is_stageered:
		return
	if current_health<=max_health/2 and not already_staggered and is_on_floor():
		already_staggered = true
		is_stageered = true
		$AnimatedSprite2D.play("Stagger")
		$StaggerTime.start()
		return
	
	
	if $Timer.is_stopped():
		$AnimatedSprite2D.play("Shooting")
		$Timer.start()
		can_shoot = true
	
	if $AnimatedSprite2D.animation == "Shooting" and $AnimatedSprite2D.frame == 3 and can_shoot:
		if  current_health>=(max_health/2):
			shoot()	
		elif current_health<max_health/2:
			print("Mwah")
			shoot1()
			shoot2()
			shoot3()
		can_shoot = false
			
	if $AnimatedSprite2D.animation == "Shooting" and $AnimatedSprite2D.frame == 6:
		$AnimatedSprite2D.play("idle")
	
				
func _physics_process(delta: float) -> void:
	if dead:
		$AnimatedSprite2D.play("Stagger")
		if $Timer_Outro.is_stopped():
			die()
		return
		
	if not $Timer_Intro.is_stopped:
		return
	if current_health==0:
		dead = true
		$Timer_Outro.start()
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor() and can_drop_to_hell:
		drop()
		can_drop_to_hell=false
	if is_stageered:
		return
	if $Timer2.is_stopped():
		var layering = randi() % 2 + 1
		layer2 = (layering + layer) % 3
		print(layer2)
		if layer2>layer and is_on_floor():
			jump(700+(layer2-layer-1)*280)
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
	#current_health = max_health / 2 - 1
	var t1 = randi() % 3
	layer = 1
	$Timer2.start()
	
	
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
	var rand = randi() % 3
	var b 
	if rand == 0:
		b= bullet.instantiate()
	if rand == 1:
		b= bullet_big.instantiate()
	if rand == 2:
		b= bullet_parry.instantiate()
	b.name="BossAmmo" + str(rand) + str(bullet_counter)
	bullet_counter+=1
	owner.add_child(b)
	b.global_transform = $Marker2D.global_transform

func shoot2():	
	var rand = randi() % 3
	var b 
	if rand == 0:
		b= bullet.instantiate()
	if rand == 1:
		b= bullet.instantiate()
	if rand == 2:
		b= bullet_parry.instantiate()
	b.name="BossAmmo" + str(rand) + str(bullet_counter)
	bullet_counter+=1
	owner.add_child(b)
	b.global_transform = $Marker2D2.global_transform

func shoot3():	
	var rand = randi() % 3
	var b 
	if rand == 0:
		b= bullet.instantiate()
	if rand == 1:
		b= bullet.instantiate()
	if rand == 2:
		b= bullet_parry.instantiate()
	b.name="BossAmmo" + str(rand) + str(bullet_counter)
	bullet_counter+=1
	owner.add_child(b)
	b.global_transform = $Marker2D3.global_transform

func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)  # Prevent negative HP
	#health_changed.emit(current_health)

		
func drop():
	position.y += 1
	
func die():
	var pos = global_position 
	queue_free()
	
	var Light = light.instantiate()  
	var a = tree.instantiate()
	a.global_transform *= 3
	owner.add_child(Light)
	Light.global_position= pos
	owner.add_child(a)
	a.global_position=pos
		
	
		
func jump(jump_velocity: float):
	velocity.y=-jump_velocity;
