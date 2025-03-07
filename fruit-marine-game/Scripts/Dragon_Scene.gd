extends Node

@onready var label = $UI/Label  # Adjust the path to your Label node
var time_left = 3  # Countdown starting number
@onready var Dragon_Cap=load("res://Scenes/Dragon_Cap.tscn")
@onready var child_node = $Dragon_Head
@onready var static_body_1 = $Environment/StaticBody2D/CollisionShape2D
@onready var static_body_2 = $Environment/StaticBody2D2/CollisionShape2D
@onready var camera = $Camera2D  # Reference to the Camera2D
var ok
var already_freed = false

func _ready():
	label.text = str(time_left)  # Set the initial number
	countdown()


func _process(delta: float) -> void:
	
	if not is_instance_valid(child_node) and not already_freed:
		already_freed = true  
		
		print("Child node was freed! Deleting static bodies...")
		if is_instance_valid(static_body_1):
			static_body_1.queue_free()
		else:
			print("StaticBody2D is already freed!")

		if is_instance_valid(static_body_2):
			static_body_2.queue_free()
		else:
			print("StaticBody2D2 is already freed!")
	
		$Phase_Switch.start()
		$Phase_Switch.timeout.connect(PhaseTwo)
			


func PhaseTwo():
	
	print("Phase Two Started! Spawning Dragon_Cap with fists.")

	# ✅ Get camera's world position
	var camera_center = camera.global_position  

	
	# ✅ Instantiate left and right fists
	var Dragon_Cap = Dragon_Cap.instantiate()

	# ✅ Set Dragon_Cap position to the floor level of the camera
	var floor_y = camera_center.y + 200  # Adjust this value for floor position
	Dragon_Cap.global_position = Vector2(camera_center.x, floor_y)

	Dragon_Cap.name="Dragon_Cap"

	get_tree().current_scene.add_child(Dragon_Cap)

	# ✅ Create a tween to move Dragon_Cap upwards
	var cap_tween = create_tween()
	cap_tween.tween_property(Dragon_Cap, "global_position", Vector2(camera_center.x, camera_center.y - 100), 1)

	print("Dragon_Cap spawned with fists and moving up!")



func countdown():
	while time_left > 0:
		await get_tree().create_timer(1.0).timeout  # Wait 1 second
		time_left -= 1
		label.text = str(time_left)  # Update countdown text
	
	label.text = "GO!"  # Show "GO!" at the end
	await get_tree().create_timer(1.0).timeout  # Wait a moment
	label.visible = false  # Hide the label after countdown
	
