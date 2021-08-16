extends "res://scripts/enemies/Enemy.gd"

export (int) var speed = 64
export (int) var acceleration = 2.5

onready var right_ray_cast = $RightRayCast
onready var left_ray_cast = $LeftRayCast
onready var up_ray_cast = $UpRayCast
onready var down_ray_cast = $DownRayCast

func _ready():
	animation = "fly"
	if direction_facing == 0:
		direction_facing = 1 if randf() > 0.5 else -1
	velocity.y = speed

func run(delta):
	if player && is_instance_valid(player):
		if left_ray_cast.is_colliding() || right_ray_cast.is_colliding():
			direction_facing *= -1
		if up_ray_cast.is_colliding():
			velocity.y += acceleration * delta
		elif down_ray_cast.is_colliding():
			velocity.y -= acceleration * delta
		
		velocity.x = direction_facing * speed
		velocity.y += sign(player.global_position.y - 8 - global_position.y) * acceleration * delta
		
		velocity = velocity.clamped(speed)
