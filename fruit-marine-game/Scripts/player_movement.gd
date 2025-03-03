extends CharacterBody2D

var scene = load("res://Scenes/glont_template.tscn")

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var  shootTime: float = 0.1

var orientation = 1
var JumpBuffer = false

func _physics_process(delta: float) -> void:
	$Timer.wait_time = shootTime
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("shoot") and $Timer.is_stopped():
		shoot()
	
	if Input.is_action_just_pressed("ui_accept"):
		$JumpBuffer.start()
	if not $JumpBuffer.is_stopped() and is_on_floor():
		$JumpBuffer.stop()
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("ui_left", "ui_right")
	
	#Handle Animations
	if $TopSprite.animation == "Shooting" and $TopSprite.frame == 3:
		$TopSprite.play("Idle")
		
	
	if direction != 0 and direction != orientation:
		self.scale.x *= -1
		orientation *= -1
		
	if is_on_floor():
		if direction == 0:
			$BottomSprite.play("Idle")
		else:
			$BottomSprite.play("Running")
	else:
		$BottomSprite.play("Jumping")
		
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
func shoot():
	$TopSprite.play("Shooting")
	
	var b = scene.instantiate()
	owner.add_child(b)
	b.global_transform = $Marker2D.global_transform
	$Timer.start()
