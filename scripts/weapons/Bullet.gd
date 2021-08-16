extends Area2D

export (int) var damage = 1
export (float) var knockback = 100
export (float) var drag = 0
export (bool) var remove_when_stopped = false
export (float) var remove_when_stopped_speed_threshold = 0.01

var velocity = Vector2.ZERO
var should_move = false

onready var lifespan_timer = $LifespanTimer

func _ready():
	# Delete bullet when it expires
	lifespan_timer.connect("timeout", self, "queue_free")
	lifespan_timer.start()

func _physics_process(delta):
	update_direction()
	
	# Move bullets after the first frame
	if should_move:
		global_position += velocity * delta
		velocity *= 1 - drag
	should_move = true
	
	if remove_when_stopped && velocity.length() < remove_when_stopped_speed_threshold:
		queue_free()

func _on_Bullet_body_entered(body):
	if body.has_method("handle_bullet_hit"):
		body.handle_bullet_hit(self)
	queue_free()

func update_direction():
	if velocity != Vector2.ZERO:
		look_at(global_position + velocity)

func set_velocity(_velocity):
	velocity = _velocity
	update_direction()
