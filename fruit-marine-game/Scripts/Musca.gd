extends Area2D

var tree = load("res://Scenes/Tree.tscn")
var light = load("res://Scenes/White Circle.tscn")
var death=0 
var retreat = 1
var attacking = 0
var pos
var duration = 7
var Checker=0
@export var time : float 
@export var speed: float = 200.0

@onready var timer_intro = $Timer_Intro
@onready var target = $"../player"
var offset

var direction = 1
var max_health = 10
var current_health: float = max_health  # ✅ Initialize health
var tween: Tween

func _ready():
	var parent = get_parent()  # Get the parent node
	offset = parent.difficulty_offset
	max_health=max_health* offset
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
func take_damage(amount: int):
	current_health = max(0, current_health - amount)
	$HitFlash.play("HitFlash")

func attack():
	 # Get direction from this object to the target CharacterBody2D
	if target:
		direction = (target.position - position).normalized()
		var distance = speed * duration  # How far to move
		var target_position = position + (direction * distance)  # Move in the directio
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", target_position, duration)
	
		
func _on_body_entered(body): 
	if body.name == "player":
		body.take_damage(1)
	if body.name.begins_with("WorldBorder"):
		tween.kill()  # Stop movement
		
func phase_two():
	
	speed=600
	$Attack.wait_time=3
	
	
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
