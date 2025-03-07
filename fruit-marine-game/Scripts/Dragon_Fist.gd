extends Area2D

var tree = load("res://Scenes/Tree.tscn")
var light = load("res://Scenes/White Circle.tscn")
var bullet = load("res://Scenes/boss_ammo.tscn")
var bullet_big = load("res://Scenes/boss_ammo_big.tscn")
var bullet_parry = load("res://Scenes/boss_ammo_parry.tscn")
var dragon_head=load("res://Scenes/Dragon_Cap.tscn")

@onready var target =get_node_or_null("$../../Player") 
@export var speed: float = 200.0
@onready var timer_intro = $Timer_Intro

var direction = 1
var max_health = 10
var current_health: float
var layer = 1
var timer
var Jump_rand
var can_shoot = true
var layer2
var bullet_counter = 0
var tween
var pos
var initial_rotation

var velocity: Vector2 = Vector2(0, 0)  # ✅ Declare velocity for manual movement
var is_falling = false  # ✅ Track if it's currently falling

	
func _physics_process(delta: float) -> void:
	if not $Attack_Timer.is_stopped():
		return
	if current_health == 0:
		die()
	if $Attack_Cooldown.is_stopped():
		attack()
	
	if is_falling:
		velocity.y += gravity * delta

func _ready():
	initial_rotation = rotation_degrees
	current_health = max_health 
	layer = 1

func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)

func attack():
	if target == null:  # ✅ Check if target exists
		print("Error: Target is null")
		return
	
	pos = target.global_position  # ✅ Use global_position

	tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(pos.x, global_position.y), 2)
	
	tween = create_tween()
	tween.chain().tween_property(self, "global_position", Vector2(global_position.x, global_position.y - 50), 1.5)  # ✅ Chained instead of overwriting

	$Attack_Timer.start()
	drop()
	
	tween = create_tween()
	tween.chain().tween_property(self, "global_position", Vector2(pos.x, global_position.y - 300), 2)  # ✅ Ensures smooth execution

func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)

func drop():  
	velocity.y = 500  # ✅ Start falling
	is_falling = true  # ✅ Enable falling behavior

func die():
	
	dragon_head.queue_free()  # ✅ Properly remove when health reaches 0
