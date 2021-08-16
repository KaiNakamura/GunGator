extends Camera2D

export (float) var speed = 1.75
export (float) var lookahead_distance = 48
export (float) var shake_decay = 0.8
export (Vector2) var max_offset = Vector2(100, 75)

var player = null
var target = Vector2.ZERO
var shake = 0

func _ready():
	randomize()

func set_player(_player):
	player = _player

func _process(dt):
	var delta = dt * Global.TARGET_FPS
	if player && is_instance_valid(player):
		target.x += (-speed if player.sprite.flip_h else speed) * delta
		target.x = clamp(target.x, -lookahead_distance, lookahead_distance)
		global_position.x = player.global_position.x + int(ease_out_sine(target.x, lookahead_distance))
		
	if shake:
		var amount = shake * shake
		offset.x = max_offset.x * amount * rand_range(-1, 1)
		offset.y = max_offset.y * amount * rand_range(-1, 1)
		shake = max(shake - shake_decay * dt, 0)

func set_shake(amount):
	if amount > shake:
		shake = amount

func ease_out_sine(x, ease_to):
	return sin((abs(x) * PI / ease_to) / 2) * sign(x) * ease_to
