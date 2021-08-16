extends Node2D

onready var player = $Player
onready var bullet_manager = $BulletManager
onready var pickup_manager = $PickupManager
onready var enemy_spawner = $EnemySpawner
onready var gui = $GUI

func _ready():
	# Connect weapons to bullet manager
	for weapon in player.weapon_manager.weapons:
		weapon.connect("fired_bullet", bullet_manager, "handle_fired_bullet")
	
	CameraManager.set_player(player)
	pickup_manager.set_player(player)
	enemy_spawner.set_player(player)
	gui.set_player(player)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		var _error = get_tree().change_scene_to(Global.MAIN_MENU)
