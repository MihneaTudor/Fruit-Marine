extends Node2D

@onready var boss = $"../boss"
@export var maxHealth = 100
@export var health = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if boss:
		maxHealth = boss.max_health
		health = boss.current_health
	
	if(health == maxHealth):
		$Health.scale.x = 0
		$HealthTween.scale.x = 0
		return
		
	$Health.scale.x = 9.99 * (maxHealth - health) / maxHealth
	$Health.position.x = -5950 + 5950 * $Health.scale.x / 9.99
	
	if $Timer.is_stopped() or true:
		var tween = create_tween()
		var time = $Timer.wait_time
		#var time = $Timer.wait_time / ($HealthTween.scale - Vector2(9.9 * (maxHealth - health) / maxHealth, $HealthTween.scale.y)).length()
		tween.tween_property($HealthTween, "scale", Vector2(9.99 * (maxHealth - health) / maxHealth, $HealthTween.scale.y), time)
		$Timer.start()
		
	$HealthTween.position.x = -5950 + 5950 * $HealthTween.scale.x / 9.99

func modify_health():
	health -= .1
