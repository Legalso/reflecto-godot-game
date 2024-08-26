extends Area2D
@onready var timer = $Timer
var is_dead = false

func _on_body_entered(body):
	print("You died!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()
	is_dead = true  # Set the death flag to true

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	is_dead = false  # Reset the death flag when the scene is reloaded
