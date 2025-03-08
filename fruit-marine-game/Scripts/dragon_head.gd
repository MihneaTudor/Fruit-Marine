extends CharacterBody2D

var tree = load("res://Scenes/Tree.tscn")
var light = load("res://Scenes/Black Circle.tscn")
var bullet = load("res://Scenes/dragon_ammo.tscn")
var bullet_parry = load("res://Scenes/dragon_ammo_parry.tscn")
var beam = load("res://Scenes/beam.tscn")

@onready var target = $"../Player"
@export var speed: float = 200.0
@export var max_health = 10
var offset
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
var just_stopped = true
@onready var holder= $"../Bullet_Holder"
	
	
func _process(delta: float) -> void:
	if $Head.animation == "attack" and $Head.frame == 1:
		$Head.play("idle")
		$Neck.play("Idle")
	if not $Timer_Intro.is_stopped():
		return
	if $Head.animation == "charge" and $Head.frame == 4 and can_shoot:
		ZeBeam()
		can_shoot = false
	if $ZeBeam.is_stopped() and not just_stopped:
		just_stopped = true
		$Head.play("idle")
		$Neck.play("Idle")
		$BEAM.queue_free()
	if $Head.animation == "charge":
		return
		
		
	  # Vibrate on X-axis (can be Y-axis too)
	
	if $Shooting_Small.is_stopped():
		$Shooting_Small.start()
		$Head.play("attack")
		shoot1()
		
	
func rotate_towards_target():
	$Neck.rotation_degrees = initial_rotatian - rotation_degrees
	if target:
		var direction = (target.position - position).normalized()  # Get direction vector
		var angle_to_target = atan2(direction.y, direction.x)  # Get angle# Create a new tween for smooth rotation
		rotation_degrees = rad_to_deg(angle_to_target)+190
		 
				
func _physics_process(delta: float) -> void:
	if not $Timer_Intro.is_stopped:
		return
	if $Head.animation == "charge":
		return
	if $ZeBeamCooldown.is_stopped() and $ZeBeam.is_stopped() and $Timer2.time_left > 1:
		$ZeBeam.start()
		$ZeBeamCooldown.start()
		$Head.play("charge")
		$Neck.play("charge")
		just_stopped = false
		can_shoot = true
	
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
	$HitFlash.play("HitFlash")
	#health_changed.emit(current_health)
func ZeBeam():
	var Ammo=beam.instantiate()
	add_child(Ammo)
	Ammo.global_transform = $Aim_Assist.global_transform
	Ammo.scale = 3 * Vector2(-1, 1)
	
	
	
func shoot1():
	var rand = randi() % 2
	var b
	if rand == 0:
		b= bullet.instantiate()
	if rand == 1:
		b= bullet_parry.instantiate()
	b.name="BossAmmo" + str(rand + 1) + str(bullet_counter)
	bullet_counter+=1
	holder.add_child(b)
	b.global_transform = $Aim_Assist.global_transform
	
func die():
	var pos = global_position 
	$"../HP".queue_free()
	queue_free()
	
	var Light = light.instantiate()  
	owner.add_child(Light)
	Light.global_position= pos
	
	
		
	
	
