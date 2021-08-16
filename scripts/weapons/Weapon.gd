extends Node2D

signal fired_bullet(bullet, position, velocity)

export (PackedScene) var Bullet
export (AudioStream) var ShootAudio
export (bool) var auto = false
export (int) var bullet_amount = 1
export (float) var speed = 300
export (float) var speed_variance = 0
export (float) var spread = 0
export (float) var camera_shake = 0.1

var direction = Vector2.ZERO
var init_velocity = Vector2.ZERO

onready var muzzle = $Muzzle
onready var animation_player = $AnimationPlayer
onready var shoot_pressed_timer = $ShootPressedTimer
onready var attack_cooldown_timer = $AttackCooldownTimer

func _process(_delta):
	if !shoot_pressed_timer.is_stopped() && attack_cooldown_timer.is_stopped():
		for _i in range(bullet_amount):
			var direction_with_spread = direction + Vector2(0, (randf() - 0.5) * spread)
			var speed_with_variance = speed + (randf() - 0.5) * speed_variance
			var init_velocity_in_firing_direction = direction.normalized() * init_velocity.dot(direction) / direction.length()
			var velocity = direction_with_spread * speed_with_variance + init_velocity_in_firing_direction
			emit_signal("fired_bullet", Bullet.instance(), muzzle.global_position, velocity)
		animation_player.play("muzzle_flash")
		AudioManager.play(ShootAudio)
		CameraManager.set_shake(camera_shake)
		attack_cooldown_timer.start()
		shoot_pressed_timer.stop()

func shoot(_direction, _init_velocity):
	direction = _direction
	init_velocity = _init_velocity
	shoot_pressed_timer.start()
	_process(0)
