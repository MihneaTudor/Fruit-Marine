extends CharacterBody2D

var scene = load("res://Scenes/glont_template.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var orientation = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("shoot") and $Timer.is_stopped():
		shoot()
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("ui_left", "ui_right")
	
	#Handle Animations
	if $Timer.is_stopped():
		$TopSprite.play("Idle")
	
	
	if direction != 0 and direction != orientation:
		self.scale.x *= -1
		orientation *= -1
		
	if direction == 0:
		$BottomSprite.play("Idle")
	else:
		$BottomSprite.play("Running")
	
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
