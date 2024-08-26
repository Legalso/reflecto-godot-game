extends Control

var game_instance = null

func set_game_instance(game):
	game_instance = game

func _ready():
	# Ensure the pause menu is always centered
	center_pause_menu()
	# Connect the viewport size change signal to re-center the menu on screen resize
	get_viewport().connect("size_changed", Callable(self, "_on_viewport_size_changed"))

func center_pause_menu():
	# Set anchors to the center of the screen
	anchor_left = 0.5
	anchor_top = 0.5
	anchor_right = 0.5
	anchor_bottom = 0.5
	
	# Ensure minimum size is set
	custom_minimum_size = Vector2(300, 200)
	
	# Adjust offsets to properly center the menu
	offset_left = -custom_minimum_size.x / 2
	offset_top = -custom_minimum_size.y / 2
	offset_right = custom_minimum_size.x / 2
	offset_bottom = custom_minimum_size.y / 2

func _on_viewport_size_changed():
	# Re-center the pause menu when the viewport size changes
	center_pause_menu()

func _on_resume_pressed():
	if game_instance != null:
		game_instance.pauseMenu()

func _on_quit_pressed():
	game_instance.pauseMenu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
