extends CharacterBody2D

var scene = load("res://Scenes/glont_template.tscn")

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -700.0
@export var  shootTime: float = 0.1
@export var max_health: int = 3

var orientation = 1
var JumpBuffer = false
var current_health: int

func _ready():
	current_health = max_health 
	#health_changed.emit(current_health)  # Emit signal for UI
	
func take_damage(amount: int):
	current_health = amount
	current_health = max(0, current_health)  # Prevent negative HP
	#health_changed.emit(current_health)
	if current_health == 0:
		die()

func heal(amount: int):
	current_health += amount
	current_health = min(max_health, current_health)  # Prevent overhealing
	#health_changed.emit(current_health)
	
func _physics_process(delta: float) -> void:
	$Timer.wait_time = shootTime
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		$CollisionShape2D.position.y = 3
		$CollisionShape2D.shape.size.y = 23.5
	else:
		
		if $CollisionShape2D.shape.size.y == 23.5 and not Input.is_action_just_released("Crouch"):
			position.y -= 9.25 * 3
		$CollisionShape2D.position.y = 0.5
		$CollisionShape2D.shape.size.y = 47
		
		if Input.is_action_pressed("Down") and not Input.is_action_pressed("Crouch") and not Input.is_action_just_released("Crouch"	):
			$CollisionShape2D.position.y = 3
			$CollisionShape2D.shape.size.y = 23.5
			position.y += 9.25 * 3
			
		
	if Input.is_action_pressed("Crouch") and is_on_floor():
		$BottomSprite.play("Jumping")
		$CollisionShape2D.position.y = 3
		$CollisionShape2D.shape.size.y = 23.5
		position.y += 9.25 * 3
		
	if Input.is_action_just_released("Crouch") and is_on_floor():
		$CollisionShape2D.position.y = 0.5
		$CollisionShape2D.shape.size.y = 47
		position.y -= 9.25 * 3
		$BottomSprite.play("Idle")
		
		
	if Input.is_action_pressed("shoot") and $Timer.is_stopped():
		shoot()
		
	if Input.is_action_pressed("Down") and is_on_floor():
		drop()
	
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
		
	if is_on_floor() and not Input.is_action_pressed("Crouch") and not Input.is_action_pressed("Down"):
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
	
func die():
	get_node("CollisionShape2D").queue_free()
	
func drop():
	position.y += 3
