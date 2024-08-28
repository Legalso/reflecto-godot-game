extends Node2D

@onready var player = $Player  # Get a reference to the player node
@onready var pause_menu = $Player/CanvasLayer/Control/PauseMenu
@onready var killzone = $Killzone

var PAUSED = false

func _ready():
	get_viewport().size = DisplayServer.screen_get_size()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pause_menu.hide()
	pause_menu.set_game_instance(self)  # Pass the instance to the PauseMenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause") and not killzone.is_dead:
		pauseMenu()
	if killzone.is_dead:
		player.ISALIVE = false
	
func pauseMenu():
	if PAUSED:
		pause_menu.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Engine.time_scale = 0
		$Player/CanvasLayer/Control/PauseMenu/MarginContainer/VBoxContainer/Resume.grab_focus()
		
	PAUSED = !PAUSED
	player.PAUSED = PAUSED  
