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
	
	if is_stageered:
		return
	
	if $Timer.is_stopped():
		shoot1()
		$Timer.start()
	
	move_and_slide()
	
func _ready():

	current_health = max_health 
	$Timer2.start()
	

func shoot1():
	var rand = randi() % 3
	var b 
	if rand == 0:
		b= bullet_parry.instantiate()
		b.name="BossAmmo2" + str(bullet_counter)
		bullet_counter+=1
		get_tree().current_scene.add_child(b)
		b.global_transform = $Marker2D.global_transform

	if rand == 1:
		b= bullet.instantiate()
		b.name="BossAmmo1"  + str(bullet_counter)
		bullet_counter+=1
		get_tree().current_scene.add_child(b)
		b.global_transform = $Marker_Sus.global_transform

	if rand == 2:
		b= bullet.instantiate()
		b.name="BossAmmo0" + str(bullet_counter)
		bullet_counter+=1
		get_tree().current_scene.add_child(b)
		b.global_transform = $Marker_Jos.global_transform

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
