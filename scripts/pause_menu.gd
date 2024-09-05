extends Control

var game_instance = null

func set_game_instance(game):
	game_instance = game

func _ready():
	get_viewport().connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	Global.current_scene = get_tree().current_scene
	print(Global.current_scene)

func _on_resume_pressed():
	if game_instance != null:
		game_instance.pauseMenu()

func _on_quit_pressed():
	game_instance.pauseMenu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_options_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")
