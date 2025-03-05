extends CharacterBody2D

var tree = load("res://Scenes/Tree.tscn")
var scene = load("res://Scenes/boss_ammo.tscn")
var light = load("res://Scenes/white_circle.tscn")

@onready var target = $"../Player"
@export var speed: float = 200.0

var direction = 1
var max_health = 10
var current_health: float
var layer=1
var timer
var Jump_rand
var can_shoot = true
var layer2
var bullet_counter = 0
var tween
var posi


func _process(delta: float) -> void:
	$AnimatedSprite2D.play("idle")
	if not $Timer_Intro.is_stopped():
		if $Timer_Intro.time_left == 0.75:
			$Timer.start()
			can_shoot=true
		return
	
func rotate_towards_target():
	if target:
		print("doi")
		var direction = (target.position - position).normalized()  # Get direction vector
		var angle_to_target = atan2(direction.y, direction.x)  # Get angle# Create a new tween for smooth rotation
		rotation_degrees = rad_to_deg(angle_to_target)+180
		$Verif.start()
		 
				
func _physics_process(delta: float) -> void:
	if not $Timer_Intro.is_stopped:
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
	current_health = max_health 
	layer = 1

	
func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)  # Prevent negative HP
	#health_changed.emit(current_health)

	
func die():
	var pos = global_position 
	queue_free()
	var Light = light.instantiate()  
	var a = tree.instantiate()
	a.global_transform *= 4
	Light.global_position= pos
	owner.add_child(a)
	a.global_position=pos
		
	
	
