extends Area2D

var tree = load("res://Scenes/Tree.tscn")
var light = load("res://Scenes/White Circle.tscn")
var bullet = load("res://Scenes/boss_ammo.tscn")
var bullet_big = load("res://Scenes/boss_ammo_big.tscn")
var bullet_parry = load("res://Scenes/boss_ammo_parry.tscn")
var dragon_head = load("res://Scenes/Dragon_Cap.tscn")
var death=0 

var retreat = 1
var attacking = 0

@export var time : float 
@export var speed: float = 200.0

@onready var timer_intro = $Timer_Intro
@onready var target = $"../../Player"

var direction = 1
var max_health = 10
var current_health: float = max_health  # ✅ Initialize health
var pos = Vector2.ZERO  # ✅ Initialize pos to prevent null errors
var tween: Tween

func _ready():
	$Delay.wait_time = time
	$Delay.start()
	
func _physics_process(delta: float) -> void:
	if not $Down_Time.is_stopped():
		return
		
	if not $Delay.is_stopped():
		return
		
	if tween and tween.is_running():
		return  # ✅ Prevent overlapping tweens
	
	if current_health == 0 and death==1:
		print("iese")
		current_health=max_health
		death=0	
		tween = create_tween()
		tween.tween_property(self, "global_position", Vector2(global_position.x, -140), 0.5)
<<<<<<< Updated upstream
=======
		$Colli.start()
>>>>>>> Stashed changes
		$Attack_Cooldown.start()
	
	if current_health == 0:
		die()
		return

	if $Attack_Cooldown.is_stopped() and attacking == 0:
		attack()

	if $Targeting.is_stopped() and attacking == 1:
		$Attack_Timer.start()
		retreat = 0
		attacking=0
		drop()

	if $Attack_Timer.is_stopped() and retreat == 0:
		move_up()
		retreat = 1
<<<<<<< Updated upstream

func take_damage(amount: int):
	current_health = max(0, current_health - amount)
=======

	

func take_damage(amount: int):
	current_health = max(0, current_health - amount)


	
>>>>>>> Stashed changes

func attack():
	if target == null:
		print("Error: Target is null")
		return
<<<<<<< Updated upstream

=======
	$CollisionShape2D.disabled = false
>>>>>>> Stashed changes
	pos = target.global_position  # ✅ Ensure position is updated correctly

	if tween:
		tween.kill()  # ✅ Ensure no other tween is interfering

	tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(pos.x, -140), 1.5)
	$Targeting.start()
	attacking = 1
	$Attack_Cooldown.start()

func drop():
	print("Dropping...")  # ✅ Debugging line to ensure function is being called

	if tween:
		tween.kill()  # ✅ Stop any existing tween

	tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(global_position.x, 160), 1)


func move_up():

	tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(pos.x, -140), 1)

func _on_body_entered(body): 
	if body.name == "Player":
		body.take_damage(1)
		
func die():
	$Down_Time.start()
	tween = create_tween()
<<<<<<< Updated upstream
	
=======
	$CollisionShape2D.disabled = true
>>>>>>> Stashed changes
	tween.tween_property(self, "global_position", Vector2(global_position.x, 160), 0.5)
	death=1	
	
