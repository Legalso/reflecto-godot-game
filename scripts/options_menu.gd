extends Control


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_volume_2_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)

func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)

func _on_resolutions_item_selected(index):
	match index: 
		0: 
			DisplayServer.window_set_size(Vector2i(640,360))
		1: 
			DisplayServer.window_set_size(Vector2i(1920,1080))
		2: 
			DisplayServer.window_set_size(Vector2i(1600,900))
		3: 
			DisplayServer.window_set_size(Vector2i(1280,720))
			

func _on_screens_item_selected(index):
	match index: 
		0: 
			DisplayServer.window_set_mode(3)
		1: 
			DisplayServer.window_set_mode(2)
		2: 
			DisplayServer.window_set_mode(0)
	
# enum WindowMode:
#● WINDOW_MODE_WINDOWED = 0
#Windowed mode, i.e. Window doesn't occupy the whole screen (unless set to the size of the screen).
#● WINDOW_MODE_MINIMIZED = 1
#Minimized window mode, i.e. Window is not visible and available on window manager's window list. Normally happens when the minimize button is pressed.
#● WINDOW_MODE_MAXIMIZED = 2
#Maximized window mode, i.e. Window will occupy whole screen area except task bar and still display its borders. Normally happens when the maximize button is pressed.
#● WINDOW_MODE_FULLSCREEN = 3
#Full screen mode with full multi-window support.
#Full screen window covers the entire display area of a screen and has no decorations. The display's video mode is not changed.
#On Windows: Multi-window full-screen mode has a 1px border of the Rendering > Environment > Defaults > Default Clear Color color.
#On macOS: A new desktop is used to display the running project.
#Note: Regardless of the platform, enabling full screen will change the window size to match the monitor's size. Therefore, make sure your project supports multiple resolutions when enabling full screen mode.
#● WINDOW_MODE_EXCLUSIVE_FULLSCREEN = 4
#A single window full screen mode. This mode has less overhead, but only one window can be open on a given screen at a time (opening a child window or application switching will trigger a full screen transition).
#Full screen window covers the entire display area of a screen and has no border or decorations. The display's video mode is not changed.
#On Windows: Depending on video driver, full screen transition might cause screens to go black for a moment.
#On macOS: A new desktop is used to display the running project. Exclusive full screen mode prevents Dock and Menu from showing up when the mouse pointer is hovering the edge of the screen.
#On Linux (X11): Exclusive full screen mode bypasses compositor.
#Note: Regardless of the platform, enabling full screen will change the window size to match the monitor's size. Therefore, make sure your project supports multiple resolutions when enabling full screen mode.
