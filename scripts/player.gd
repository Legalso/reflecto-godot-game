extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var JUMP_AVAILABLE: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var animated_sprite = $AnimatedSprite2D
var paused = false  # Declare the paused variable
var COYOTE_TIME: float = 0.2
@onready var coyote_timer = $Coyote_Timer

func _process(delta):
	if not paused:
		if JUMP_AVAILABLE:
			if coyote_timer.is_stopped():
				coyote_timer.start(COYOTE_TIME)
		else:
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta
			else: 
				JUMP_AVAILABLE = true
				coyote_timer.stop()

		# Handle jump.
		if Input.is_action_just_pressed("jump") and JUMP_AVAILABLE:
			velocity.y = JUMP_VELOCITY
			JUMP_AVAILABLE = false

		# Get the input direction -1, 0, 1
		var direction = Input.get_axis("move_left", "move_right")
		
		# Update horizontal velocity
		velocity.x = direction * SPEED
		
		# Move the character
		move_and_slide()

		# Flips the Sprite
		if direction > 0: 
			animated_sprite.flip_h = false
		elif direction < 0: 
			animated_sprite.flip_h = true
		
		# Play animations
		if is_on_floor():
			if direction == 0: 
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else: 
			animated_sprite.play("jump")
			
func Coyoye_Timeout():
	JUMP_AVAILABLE = false
