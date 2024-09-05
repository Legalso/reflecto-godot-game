extends Control

var previous_scene = ""

func _ready():
	previous_scene = str(Global.current_scene)
	Global.current_scene = str(get_tree().current_scene)
	print(Global.current_scene)

func _on_back_pressed():
	if previous_scene == "res://scenes/menu.tscn":
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	else:
		Global.current_scene = previous_scene
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		var PAUSED = false
		PAUSED = false
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_volume_2_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)

func _on_resolutions_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(640, 360))
		1:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		2:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		3:
			DisplayServer.window_set_size(Vector2i(1280, 720))

func _on_screens_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_mode(3)
		1:
			DisplayServer.window_set_mode(2)
		2:
			DisplayServer.window_set_mode(0)
