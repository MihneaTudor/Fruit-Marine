extends Area2D

@export var tree = load("res://Scenes/Tree.tscn")
var light = load("res://Scenes/White Circle.tscn")
var death=0 
var retreat = 1
var attacking = 0
var pos
var duration = 7
var Checker=0
@export var time : float 
var speed: float = 400

@onready var timer_intro = $Timer_Intro
@onready var target = $"../player"
var offset = 1

var direction = 1
@export var max_health = 50
var current_health: float = max_health  # ✅ Initialize health
var tween: Tween

func _ready():
	max_health=max_health* Offset.get_counter()
	current_health=max_health
	
func _physics_process(delta: float) -> void:
	
	if not $Timer_Intro.is_stopped():
		return
	if $Attack.is_stopped():
		attack()
		$Attack.start()
	if current_health==max_health/2 and Checker==0:
		phase_two()
		Checker=1
		
	if current_health == 0:
		die()
		
func take_damage(amount: int):
	current_health = max(0, current_health - amount)
	$HitFlash.play("HitFlash")

func attack():
	$AnimatedSprite2D.play("attack")
	 # Get direction from this object to the target CharacterBody2D
	if target:
		if target.position.x > position.x:
			self.scale.x = -1 * self.scale.y
		if target.position.x <= position.x:
			self.scale.x = 1 * self.scale.y
		
		direction = (target.position - position).normalized()
		var distance = speed * duration  # How far to move
		var target_position = position + (direction * distance)  # Move in the directio
		
		var time = position.distance_to(target.position) / speed
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", target.position, time)
		tween.finished.connect(_on_tween_finished)  # Connect signal properly

func _on_tween_finished():
	$AnimatedSprite2D.play("Idle")
	
		
func _on_body_entered(body): 
	if body.name == "player":
		body.take_damage(1)
	if body.name.begins_with("WorldBorder"):
		tween.kill()  # Stop movement
		
func phase_two():
	
	#duration = 1
	speed=625
	$Attack.wait_time=1.5
	
	
func die():
	var pos = global_position 
	$"../HP".queue_free()
	queue_free()
	var Light = light.instantiate()  
	var a = tree.instantiate()
	a.global_transform *= 3
	owner.add_child(Light)
	Light.global_position= pos
	owner.add_child(a)
	a.global_position=pos
