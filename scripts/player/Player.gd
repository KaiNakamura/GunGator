extends KinematicBody2D

signal score_changed(new_score)
signal player_died()

const ACCELERATION = 20
const MAX_SPEED = 192
const FRICTION = 0.3
const AIR_FRICTION = 0.2
const JUMP_START_FORCE = 335
const JUMP_FORCE = 15
const JUMP_STOP_FORCE = 50
const GRAVITY = 30
const MAX_FALL_SPEED = 250

export (AudioStream) var JumpAudio
export (AudioStream) var HitAudio
export (AudioStream) var DieAudio
export (AudioStream) var CratePickupAudio
export (float) var die_camera_shake = 0.2
export (int) var max_health = 1

var velocity = Vector2.ZERO
var health = max_health
var score = 0
var animation = "idle"

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var jump_pressed_timer = $JumpPressedTimer
onready var grounded_timer = $GroundedTimer
onready var invincibility_timer = $InvincibilityTimer
onready var weapon_manager = $WeaponManager

func _physics_process(dt):
	var delta = dt * Global.TARGET_FPS
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# Horizontal movement
	if x_input != 0:
		velocity.x += x_input * ACCELERATION * delta
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		animation = "run"
		sprite.flip_h = x_input < 0
	else:
		animation = "idle"
	
	# Weapon manager
	weapon_manager.set_direction(Vector2(-1 if sprite.flip_h else 1, 0))
	weapon_manager.set_init_velocity(velocity)
	
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("ui_jump"):
		jump_pressed_timer.start()
	
	var apply_friction = x_input == 0 or x_input != sign(velocity.x)
	
	if is_on_floor():
		grounded_timer.start()
		if apply_friction:
			# Apply ground friction
			velocity.x = lerp(velocity.x, 0, pow(FRICTION, delta))
	else:
		animation = "jump"
		if velocity.y > 0:
			# Faster falling feels nice
			velocity.y += JUMP_STOP_FORCE
		elif Input.is_action_pressed("ui_jump"):
			# Jump higher while holding up
			velocity.y -= JUMP_FORCE * delta
		if apply_friction:
			# Apply air friction
			velocity.x = lerp(velocity.x, 0, pow(AIR_FRICTION, delta))
	
	if !jump_pressed_timer.is_stopped() && !grounded_timer.is_stopped():
		# Jump!
		velocity.y = -JUMP_START_FORCE
		jump_pressed_timer.stop()
		grounded_timer.stop()
		AudioManager.play(JumpAudio, -12)
	
	# Cap fall speed
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	# Play animation
	animation_player.play(animation)
	sprite.visible = get_invincibility_frame()
	
	# Update velocity
	velocity = move_and_slide(velocity, Vector2.UP)

func handle_enemy_hit():
	if invincibility_timer.is_stopped():
		health -= 1
		AudioManager.play(HitAudio)
		if health <= 0:
			die()
		else:
			invincibility_timer.start()

func handle_sludge_entered():
	die()

func die():
	AudioManager.play(DieAudio)
	CameraManager.set_shake(die_camera_shake)
	emit_signal("player_died")
	queue_free()

func handle_crate_pickup():
	score += 1
	emit_signal("score_changed", score)
	weapon_manager.switch_random_weapon()
	AudioManager.play(CratePickupAudio)

func get_invincibility_frame():
	if invincibility_timer.is_stopped():
		return true
	else:
		var t = -sin(20 * PI * pow(invincibility_timer.time_left / invincibility_timer.wait_time, 2))
		return t < 0
