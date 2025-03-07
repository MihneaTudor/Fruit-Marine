extends CharacterBody2D

var tree = load("res://Scenes/Tree.tscn")
var light = load("res://Scenes/White Circle.tscn")
var bullet = load("res://Scenes/boss_ammo.tscn")
var bullet_big = load("res://Scenes/boss_ammo_big.tscn")
var bullet_parry = load("res://Scenes/boss_ammo_parry.tscn")

@onready var target = $"../Player"
@export var speed: float = 200.0
@export var max_health = 10

var direction = 1
var current_health: float
var layer=1
var timer
var Jump_rand
var can_shoot = true
var layer2
var bullet_counter = 0
var tween
var posi
var initial_rotatian

	
	
func _process(delta: float) -> void:
	$Head.play("idle")
	if not $Timer_Intro.is_stopped():
		return
	if not $ZeBeam.is_stopped():
		return
	if not $Warmup.is_stopped():
		return
		
		
	  # Vibrate on X-axis (can be Y-axis too)
	
	if $Shooting_Small.is_stopped():
		$Shooting_Small.start()
		shoot1()
		
	
func rotate_towards_target():
	$Neck.rotation_degrees = initial_rotatian - rotation_degrees
	if target:
		var direction = (target.position - position).normalized()  # Get direction vector
		var angle_to_target = atan2(direction.y, direction.x)  # Get angle# Create a new tween for smooth rotation
		rotation_degrees = rad_to_deg(angle_to_target)+190
		$Verif.start()
		 
				
func _physics_process(delta: float) -> void:
	if not $Timer_Intro.is_stopped:
		return
	if $ZeBeamCooldown.is_stopped() and $ZeBeam.is_stopped() and $Timer2.time_left > 1:
		$ZeBeam.start()
		$ZeBeamCooldown.start()
		
	if not $ZeBeam.is_stopped():
		ZeBeam()
		return
	
	rotate_towards_target()
	
	if current_health==0:
		die()
	
	if $Timer2.is_stopped():
		var layering = randi() % 2 + 1
		layer2 = (layering + layer) % 3
		tween= get_tree().create_tween()
		tween.tween_property(self, "position", Vector2(position.x, position.y-(layer2-layer)*230 ), 3*abs(layer2-layer))
		layer=layer2
		$Timer2.start()
		move_and_slide()
	
func _ready():
	initial_rotatian = rotation_degrees
	current_health = max_health 
	layer = 1

	
func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)  # Prevent negative HP
	#health_changed.emit(current_health)
func ZeBeam():
	var Ammo=bullet.instantiate()
	get_tree().current_scene.add_child(Ammo)
	Ammo.global_transform = $Aim_Assist.global_transform
	
	
	
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
	get_tree().current_scene.add_child(b)
	b.global_transform = $Aim_Assist.global_transform
	
func die():
	queue_free()
	$"../HP".queue_free()
	
	
		
	
	
