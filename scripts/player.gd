extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var COYOTE_TIMER = $Coyote_Timer

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var FALL_GRAVITY = GRAVITY + (GRAVITY * 0.35)
var PAUSED = false
var ISALIVE = true
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var JUMP_AVAILABLE: bool = true
const JUMP_MAX = 2
var JUMP_COUNT = 0
const COYOTE_TIME: float = 0.3

func _process(delta):
	if ISALIVE and not PAUSED:
		if is_on_floor():
			JUMP_COUNT = 0
			JUMP_AVAILABLE = true
			COYOTE_TIMER.stop()
		else:
			velocity.y += Get_gravity_v2(velocity) * delta
			if COYOTE_TIMER.is_stopped() and COYOTE_TIMER.time_left == 0:
				COYOTE_TIMER.start(COYOTE_TIME)

		# Verificar o primeiro salto (jump1)
		if Input.is_action_just_pressed("jump"):
			if JUMP_AVAILABLE and (is_on_floor() or not COYOTE_TIMER.is_stopped()):
				velocity.y = JUMP_VELOCITY
				JUMP_COUNT += 1
				if JUMP_COUNT >= JUMP_MAX:
					JUMP_AVAILABLE = false
				# Desabilitar JUMP_AVAILABLE após o primeiro salto
				if JUMP_COUNT == 1:
					JUMP_AVAILABLE = false

		# Verificar o segundo salto (jump2)
		if Input.is_action_just_pressed("jump") and JUMP_COUNT == 1 and not is_on_floor():
			velocity.y = JUMP_VELOCITY
			JUMP_COUNT += 1

		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = JUMP_VELOCITY / 4

		var direction = Input.get_axis("move_left", "move_right")
		velocity.x = direction * SPEED
		
		move_and_slide()

		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true

		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

func Coyoye_Timeout():
	# Desabilita o pulo se o personagem não estiver no chão e o Coyote Time acabar
	if not is_on_floor() and JUMP_COUNT == 0:
		JUMP_AVAILABLE = false

func Get_gravity_v2(velocity: Vector2):
	if velocity.y < 0:
		return GRAVITY
	else:
		return FALL_GRAVITY
