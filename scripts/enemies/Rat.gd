extends "res://scripts/enemies/Enemy.gd"

export (int) var speed = 85

onready var right_ray_cast = $RightRayCast
onready var left_ray_cast = $LeftRayCast

func _ready():
	if direction_facing == 0:
		direction_facing = 1 if randf() > 0.5 else -1

func run(delta):
	# Apply gravity
	velocity.y += gravity * delta
	
	# Cap fall speed
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
		
	# Horizontal movement
	if direction_facing != 0:
		velocity.x = direction_facing * speed
		animation = "run"
	else:
		animation = "idle"
	
	# Collision
	if left_ray_cast.is_colliding():
		direction_facing = 1
	elif right_ray_cast.is_colliding():
		direction_facing = -1

func set_direction_facing(_direction_facing):
	direction_facing = _direction_facing
