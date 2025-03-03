extends HBoxContainer

@export var HeartFull: Texture
@export var HeartEmpty: Texture
@export var player: CharacterBody2D  # Assign player in the editor

func _process(delta: float) -> void:
	#player.get_script().health_changed.connect(update_hearts)
	update_hearts(player.current_health)

func update_hearts(health):
	for i in range(get_child_count()):
		var heart = get_child(i)
		if heart is TextureRect:
			heart.texture = HeartFull if i < health else HeartEmpty
