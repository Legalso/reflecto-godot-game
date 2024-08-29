extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var COYOTE_TIMER = $Coyote_Timer
@onready var joystick = $"../UInode/UI/Virtual Joystick"

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

const DASH_SPEED = 500.0  # Velocidade fixa para o dash
var DASHING = false
var CAN_DASH = true
var DASH_DIRECTION = Vector2.ZERO  # Direção do dash (mantida fixa durante o dash)

# Duração do dash baseado na distância desejada e velocidade
const DASH_DURATION = 0.12  # Duração fixa para o dash (em segundos)

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

		# Verificar o primeiro salto (jump1)
		if Input.is_action_just_pressed("jump"):
			if JUMP_AVAILABLE and (is_on_floor() or not COYOTE_TIMER.is_stopped()):
				velocity.y = JUMP_VELOCITY
				JUMP_COUNT += 1
				if JUMP_COUNT >= JUMP_MAX:
					JUMP_AVAILABLE = false
				if JUMP_COUNT == 1:
					JUMP_AVAILABLE = false

		# Verificar o segundo salto (jump2)
		if Input.is_action_just_pressed("jump") and JUMP_COUNT == 1 and not is_on_floor():
			velocity.y = JUMP_VELOCITY
			JUMP_COUNT += 1

		# Aplica queda mais rápida se o pulo for interrompido
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = JUMP_VELOCITY / 4

		# Verifica e aplica o dash
		if Input.is_action_just_pressed("dash") and CAN_DASH:
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
			# Combine o input do teclado/mouse com o do joystick
			var direction = Input.get_axis("move_left", "move_right")
			if joystick.is_pressed:
				direction = joystick.output.x  # Use o valor do joystick se estiver sendo pressionado
			
			velocity.x = direction * SPEED

		move_and_slide()

		# Inverte o sprite do personagem com base na direção, se não estiver dashando
		if not DASHING:
			if velocity.x > 0:
				animated_sprite.flip_h = false
			elif velocity.x < 0:
				animated_sprite.flip_h = true

		# Controla as animações do personagem com base no estado
		if is_on_floor():
			if velocity.x == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

# Desabilita o pulo se o personagem não estiver no chão e o Coyote Time acabar
func Coyoye_Timeout():
	if not is_on_floor() and JUMP_COUNT == 0:
		JUMP_AVAILABLE = false

# Função para definir a gravidade com base no movimento do personagem
func Get_gravity_v2(velocity: Vector2):
	if velocity.y < 0:
		return GRAVITY
	else:
		return FALL_GRAVITY

# Timer que controla o final do dash
func _on_dash_timer_timeout():
	DASHING = false  # Finaliza o dash

# Timer para resetar a possibilidade de dashar (não necessário com a lógica atual, mas pode ser útil em algumas implementações)
func _on_dash_rebounce_timeout():
	CAN_DASH = true  # Reabilita o dash após um tempo (não usado atualmente)
