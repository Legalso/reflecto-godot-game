extends Node2D

@onready var player = $Player  # Get a reference to the player node
@onready var pause_menu = $Player/CanvasLayer/Control/PauseMenu
@onready var killzone = $Killzone

var paused = false

func _ready():
	pause_menu.hide()
	pause_menu.set_game_instance(self)  # Pass the instance to the PauseMenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause") and not killzone.is_dead:
		pauseMenu()
	
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused
	player.paused = paused  
