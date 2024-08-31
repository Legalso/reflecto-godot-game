extends CharacterBody2D

@onready var game = $".."
@onready var animated_sprite = $AnimatedSprite2D
@onready var COYOTE_TIMER = $Coyote_Timer
@onready var joystick = $"../UInode/UI/Virtual Joystick"
@onready var randomized_audio = $RandomizedAudio
@onready var ray_cast_2d_right = $RayCast2D_right
@onready var ray_cast_2d_left = $RayCast2D_left

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var FALL_GRAVITY = GRAVITY + (GRAVITY * 0.40)
var WALL_GRAVITY = GRAVITY * 0.10  #90% less gravity when touching a wall
var PAUSED = false
var ISALIVE = true
const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var JUMP_AVAILABLE: bool = true
const JUMP_MAX = 2
var JUMP_COUNT = 0
const COYOTE_TIME: float = 0.4
var JUMP_SOUND = preload("res://assets/sounds/jump.wav")
# var WALL_JUMP_REPEL_FORCE = 1000

const DASH_SPEED = 500.0  # Velocidade fixa para o dash
var DASHING = false
var CAN_DASH = true
var DASH_DIRECTION = Vector2.ZERO  # Direção do dash (mantida fixa durante o dash)
var DASH_SOUND = preload("res://assets/sounds/power_up.wav") 

@export var sfx_footstpes : AudioStream
# @export var jump_sound : AudioStream
var footstep_frames : Array = [1,5,9,13]

# Duração do dash baseado na distância desejada e velocidade
const DASH_DURATION = 0.12  # Duração fixa para o dash (em segundos)

var collision_disabled = false
var collision_disable_timer = Timer.new()

# track if the player is touching a wall
var touching_wall = false

# save position
var pos = []

func _ready():
	animated_sprite = $AnimatedSprite2D
	add_child(collision_disable_timer)
	collision_disable_timer.connect("timeout", Callable(self, "_on_collision_disable_timeout"))

func _process(delta):
	if ISALIVE and not PAUSED:
		if is_on_floor():
			JUMP_COUNT = 0
			JUMP_AVAILABLE = true
			CAN_DASH = true  # Permite dash novamente ao tocar no chão
			COYOTE_TIMER.stop()
		else:
			velocity.y += Get_gravity_v2(velocity) * delta
			if COYOTE_TIMER.is_stopped() and COYOTE_TIMER.time_left == 0:
				COYOTE_TIMER.start(COYOTE_TIME)

		# Verificar o primeiro ou segundo salto (jump1 ou jump2)
		if Input.is_action_just_pressed("jump") and (JUMP_AVAILABLE and (is_on_floor() or not COYOTE_TIMER.is_stopped()) or (JUMP_COUNT == 1 and not is_on_floor())):
			if JUMP_SOUND:
				randomized_audio.custom_play(JUMP_SOUND)  # Pass the jump sound
			velocity.y = JUMP_VELOCITY
			JUMP_COUNT += 1
			if JUMP_COUNT >= JUMP_MAX:
				JUMP_AVAILABLE = false
				
			# Wall climb
			# TODO: optimize and fix this 'Gambiarra'
			# TODO: add bounce after hitting wall --> need to rebuild all the walk code
			if ray_cast_2d_right.is_colliding() and ISALIVE:
				var collider = ray_cast_2d_right.get_collider()
				if collider.name == "TileMapLayer":
					JUMP_COUNT = 1
					# velocity.x = -WALL_JUMP_REPEL_FORCE  # Repel to the left
					disable_collision_temporarily()
			if ray_cast_2d_left.is_colliding() and ISALIVE:
				var collider = ray_cast_2d_left.get_collider()
				if collider.name == "TileMapLayer":
					JUMP_COUNT = 1
					# velocity.x = WALL_JUMP_REPEL_FORCE  # Repel to the right
					disable_collision_temporarily()

		# Aplica queda mais rápida se o pulo for interrompido
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = JUMP_VELOCITY / 4

		# Verifica e aplica o dash
		if Input.is_action_just_pressed("dash") and CAN_DASH:
			if DASH_SOUND:
				randomized_audio.custom_play(DASH_SOUND)  # Passa o som do dash
			DASHING = true
			CAN_DASH = false  # Desabilita o dash até tocar no chão
			DASH_DIRECTION = Vector2(sign(velocity.x), 0)  # Direção do dash (horizontal)
			if DASH_DIRECTION == Vector2.ZERO:
				DASH_DIRECTION = Vector2(-1 if animated_sprite.flip_h else 1, 0)  # Usando a sintaxe correta do operador ternário
			$dash_timer.start(DASH_DURATION)  # Inicia o dash com duração fixa

		# Durante o dash, mantém a velocidade constante na direção do dash
		if DASHING:
			velocity = DASH_DIRECTION * DASH_SPEED
		else:
			# Aplica velocidade normal quando não está dashando
			var direction = Input.get_axis("move_left", "move_right")
			
			velocity.x = direction * SPEED

		if not collision_disabled:
			move_and_slide()

		# Inverte o sprite do personagem com base na direção, se não estiver dashando
		if not DASHING and animated_sprite != null:
			if velocity.x > 0:
				animated_sprite.flip_h = false
			elif velocity.x < 0:
				animated_sprite.flip_h = true

		# Controla as animações do personagem com base no estado
		if animated_sprite != null:
			if is_on_floor():
				if velocity.x == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			else:
				animated_sprite.play("jump")
			if DASHING:
				animated_sprite.play("dash")	

		# Update touching_wall state
		touching_wall = ray_cast_2d_right.is_colliding() or ray_cast_2d_left.is_colliding()

# Desabilita o pulo se o personagem não estiver no chão e o Coyote Time acabar
func Coyoye_Timeout():
	if not is_on_floor() and JUMP_COUNT == 0:
		JUMP_AVAILABLE = false

# Função para definir a gravidade com base no movimento do personagem
func Get_gravity_v2(velocity: Vector2):
	if touching_wall and velocity.y > 0:
		return WALL_GRAVITY
	elif velocity.y < 0:
		return GRAVITY
	else:
		return FALL_GRAVITY

# Timer que controla o final do dash
func _on_dash_timer_timeout():
	DASHING = false  # Finaliza o dash

# Timer para resetar a possibilidade de dashar (não necessário com a lógica atual, mas pode ser útil em algumas implementações)
func _on_dash_rebounce_timeout():
	CAN_DASH = true  # Reabilita o dash após um tempo (não usado atualmente)

# Temporarily disable collision detection
func disable_collision_temporarily():
	collision_disabled = true
	collision_disable_timer.start(0.1)  # Disable collision for 0.1 seconds

# Re-enable collision detection
func _on_collision_disable_timeout():
	collision_disabled = false
	
func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load

func _on_animated_sprite_2d_frame_changed():
	if animated_sprite == null:
		return
	if animated_sprite.animation == "idle":
		return
	if animated_sprite.animation == "jump":
		return
	if animated_sprite.animation == "dash":
		return
	load_sfx(sfx_footstpes)
	if animated_sprite.frame in footstep_frames:
		%sfx_player.play()

func save(): 
	pos.append(position.x)
	pos.append(position.y)
	game.pos_dict[name] = pos
	game.save_game()

func update_pos(p):
	position = p
