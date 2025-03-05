extends Node

@onready var label = $UI/Label  # Adjust the path to your Label node
var time_left = 3  # Countdown starting number

func _ready():
	label.text = str(time_left)  # Set the initial number
	countdown()

func countdown():
	while time_left > 0:
		await get_tree().create_timer(1.0).timeout  # Wait 1 second
		time_left -= 1
		label.text = str(time_left)  # Update countdown text
	
	label.text = "GO!"  # Show "GO!" at the end
	await get_tree().create_timer(1.0).timeout  # Wait a moment
	label.visible = false  # Hide the label after countdown
