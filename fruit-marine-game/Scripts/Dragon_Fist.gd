extends Area2D

var tree = load("res://Scenes/Tree.tscn")
var light = load("res://Scenes/White Circle.tscn")
var bullet = load("res://Scenes/boss_ammo.tscn")
var bullet_big = load("res://Scenes/boss_ammo_big.tscn")
var bullet_parry = load("res://Scenes/boss_ammo_parry.tscn")
var dragon_head = load("res://Scenes/Dragon_Cap.tscn")

var retreat = 1
var attacking = 0
@onready var target = $"../../Player"
@export var speed: float = 200.0
@onready var timer_intro = $Timer_Intro

var direction = 1
var max_health = 10
var current_health: float = max_health  # ✅ Initialize health
var pos = Vector2.ZERO  # ✅ Initialize pos to prevent null errors
var tween: Tween

func _physics_process(delta: float) -> void:
	if tween and tween.is_running():
		return  # ✅ Prevent overlapping tweens

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

func take_damage(amount: int):
	current_health = max(0, current_health - amount)

func attack():
	if target == null:
		print("Error: Target is null")
		return

	pos = target.global_position  # ✅ Ensure position is updated correctly

	if tween:
		tween.kill()  # ✅ Ensure no other tween is interfering

	tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(pos.x, -450), 2)
	$Targeting.start()
	attacking = 1

func drop():
	print("Dropping...")  # ✅ Debugging line to ensure function is being called

	if tween:
		tween.kill()  # ✅ Stop any existing tween

	tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(global_position.x, 50), 2)
	tween.finished.connect(func(): print("Drop animation completed"))  # ✅ Debugging confirmation

func move_up():
	if tween:
		tween.kill()  # ✅ Stop any existing tween before moving up

	tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(pos.x, -450), 2)

func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)

func die():
	print("Boss defeated!")  # ✅ Debugging output
	queue_free()
