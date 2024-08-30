extends Area2D

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer  # Assuming you have an AudioStreamPlayer node as a child

var COIN_SOUND = preload("res://assets/sounds/coin.wav")

func _on_body_entered(body):
	game_manager.add_point()
	animation_player.play("pickup")
	if COIN_SOUND:
		audio_player.stream = COIN_SOUND  # Set the audio stream
		audio_player.play()  # Play the sound
		print("Coin sound loaded successfully")
	else:
		print("Coin sound not loaded")
