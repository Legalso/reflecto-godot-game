extends Node2D

@onready var player = $Player  # Get a reference to the player node
@onready var pause_menu = $Player/CanvasLayer/Control/PauseMenu
@onready var killzone = $Killzone
@onready var ui_node = $UInode/UI

var PAUSED = false

func _ready():
	get_viewport().size = DisplayServer.screen_get_size()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pause_menu.hide()
	pause_menu.set_game_instance(self)  # Pass the instance to the PauseMenu
	#save_game(1)
	#load_game(1)
	
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

# Save system
var pos_dict = {}

func save():
	var save_dict = {
		"score" : 1740,
		"username" : "Test",
		"position" : pos_dict
	}	
	return save_dict
	
func save_game():
	var save_game = FileAccess.open_encrypted_with_pass("user://reflectosave.save", FileAccess.WRITE, "Legalso")
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://reflectosave.save"):
		return
	
	var save_game = FileAccess.open_encrypted_with_pass("user://reflectosave.save", FileAccess.READ, "Legalso")
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		for i in node_data["position"]:
			var pos = Vector2(node_data["position"][i][0],node_data["position"][i][1])
			print(pos)
			get_node(i).update_pos(pos)
			
		print(node_data)
