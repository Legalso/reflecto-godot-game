extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var JUMP_AVAILABLE: bool = true
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") # Obtém a gravidade das configurações do projeto.
@onready var animated_sprite = $AnimatedSprite2D
var PAUSED = false  # Variável que pausa o movimento
var COYOTE_TIME: float = 0.2 # tempo do coyote time
@onready var COYOTE_TIMER = $Coyote_Timer
var ISALIVE = true
var JUMP_MAX = 2  # Máximo de saltos (2 para pulo duplo)
var JUMP_COUNT = 0  # Contador de saltos

func _process(delta):
	if ISALIVE and not PAUSED:
		# Verifica se o personagem está no chão
		if is_on_floor():
			# Reseta o contador de saltos ao tocar no chão
			JUMP_COUNT = 0
			JUMP_AVAILABLE = true  # Habilita o salto
			COYOTE_TIMER.stop()  # Para o coyote timer
		else:
			# Se não estiver no chão, aplica a gravidade
			velocity.y += GRAVITY * delta
			
			# Inicia o coyote timer caso ele não esteja rodando
			if COYOTE_TIMER.is_stopped():
				COYOTE_TIMER.start(COYOTE_TIME)

		# Verifica se o jogador pressionou o botão de pulo e se o pulo está disponível
		if Input.is_action_just_pressed("jump") and JUMP_COUNT < JUMP_MAX:
			velocity.y = JUMP_VELOCITY  # Aplica a velocidade de pulo
			JUMP_COUNT += 1  # Incrementa o contador de saltos
			
			# Se o contador de saltos for igual ao máximo, desabilita o pulo
			if JUMP_COUNT >= JUMP_MAX:
				JUMP_AVAILABLE = false

		# Captura a direção do movimento (-1 para esquerda, 1 para direita)
		var direction = Input.get_axis("move_left", "move_right")
		
		# Atualiza a velocidade horizontal
		velocity.x = direction * SPEED
		
		# Move o personagem
		move_and_slide()

		# Inverte o sprite baseado na direção
		if direction > 0: 
			animated_sprite.flip_h = false
		elif direction < 0: 
			animated_sprite.flip_h = true
		
		# Toca as animações baseadas no estado do personagem
		if is_on_floor():
			if direction == 0: 
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else: 
			animated_sprite.play("jump")
			
# Função chamada quando o coyote timer termina
func Coyoye_Timeout():
	if not is_on_floor() and JUMP_COUNT >= JUMP_MAX:
		JUMP_AVAILABLE = false  # Desabilita o pulo se o personagem já usou todos os saltos
