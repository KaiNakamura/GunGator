extends KinematicBody2D

signal sludge_entered(enemy)

export (AudioStream) var HitAudio
export (AudioStream) var DieAudio
export (AudioStream) var SplashAudio
export (int) var gravity = 10
export (int) var max_fall_speed = 250
export (float) var hit_camera_shake = 0.1
export (float) var die_camera_shake = 0.12
export (int) var health = 1
export (int) var direction_facing = 0

var velocity = Vector2.ZERO
var animation = "idle"

var player = null
var enemy_spawner = null
var dead = false

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var flash_timer = $FlashTimer
onready var hitbox = $Hitbox

func set_player(_player):
	player = _player

func set_enemy_spawner(_enemy_spawner):
	enemy_spawner = _enemy_spawner
	var _error = connect("sludge_entered", enemy_spawner, "handle_enemy_entered_sludge")

func _physics_process(dt):
	var delta = dt * Global.TARGET_FPS
	
	if dead:
		animation = "die"
		# Apply gravity
		velocity.y += gravity * delta
		
		# Cap fall speed
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
		
		global_position += velocity * dt
	else:
		# Handle hits
		for body in hitbox.get_overlapping_bodies():
			if body.has_method("handle_enemy_hit"):
				body.handle_enemy_hit()
		
		run(delta)
		
		# Update velocity
		velocity = move_and_slide(velocity, Vector2.UP)
	
	# Play animation
	sprite.flip_h = direction_facing < 0
	animation_player.play(animation)
	if flash_timer.is_stopped():
		sprite.set_material(null)
	else:
		sprite.set_material(Global.white_shader_material)

func run(_delta):
	pass

func handle_bullet_hit(bullet):
	if dead:
		return
	
	health -= bullet.damage
	AudioManager.play(HitAudio)
	CameraManager.set_shake(hit_camera_shake)
	flash_timer.start()
	if health <= 0:
		velocity = (bullet.velocity.normalized() + Vector2.UP) * bullet.knockback
		die()

func handle_sludge_entered():
	if dead:
		return
	
	AudioManager.play(SplashAudio)
	emit_signal("sludge_entered", self)
	call_deferred("queue_free")

func die():
	AudioManager.play(DieAudio)
	CameraManager.set_shake(die_camera_shake)
	dead = true

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("queue_free")
