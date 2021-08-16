extends KinematicBody2D

signal crate_pickup()

const GRAVITY = 20
const MAX_FALL_SPEED = 250

var pickup_manager = null
var velocity = Vector2.ZERO

func set_pickup_manager(_pickup_manager):
	pickup_manager = _pickup_manager
	var _error = connect("crate_pickup", pickup_manager, "handle_crate_pickup")

func _physics_process(dt):
	var delta = dt * Global.TARGET_FPS
	
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	# Cap fall speed
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	# Update velocity
	var _collision = move_and_collide(velocity * dt)
	

func _on_Hitbox_body_entered(body):
	if body.has_method("handle_crate_pickup"):
		body.handle_crate_pickup()
		emit_signal("crate_pickup")
		call_deferred("queue_free")
