# pause_menu.gd
extends Control
var game_instance = null

func set_game_instance(game):
	game_instance = game

func _on_resume_pressed():
	if game_instance != null:
		game_instance.pauseMenu()

func _on_quit_pressed():
	game_instance.pauseMenu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
