extends Node

func handle_fired_bullet(bullet, position, velocity):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_velocity(velocity)
