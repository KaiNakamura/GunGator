extends Node2D

signal weapon_changed(weapon)

var weapons = []
var direction = Vector2.ZERO
var init_velocity = Vector2.ZERO

onready var current_weapon = $Pistol

func _ready():
	weapons = get_children()
	for weapon in weapons:
		weapon.hide()
	current_weapon.show()

func _process(_delta):
	if direction != Vector2.ZERO:
		scale.x = direction.x
	if current_weapon.auto && Input.is_action_pressed("ui_shoot"):
		current_weapon.shoot(direction, init_velocity)

func _unhandled_input(event):
	if !current_weapon.auto && event.is_action_pressed("ui_shoot"):
		current_weapon.shoot(direction, init_velocity)

func get_current_weapon():
	return current_weapon

func switch_weapon(weapon):
	if weapon == current_weapon:
		return
	current_weapon.hide()
	weapon.show()
	current_weapon = weapon
	emit_signal("weapon_changed", current_weapon)

func switch_random_weapon():
	var possible_weapons = []
	for weapon in weapons:
		if weapon != current_weapon:
			possible_weapons.append(weapon)
	switch_weapon(possible_weapons[randi() % possible_weapons.size()])

func set_direction(_direction):
	direction = _direction

func set_init_velocity(_init_velocity):
	init_velocity = _init_velocity
