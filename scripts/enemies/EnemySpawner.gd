extends Position2D

export (float) var max_spawn_time = 2
export (float) var min_spawn_time = 1
export (float) var difficulty_multiplier = 0.015
export (PackedScene) var Rat
export (PackedScene) var Bat
export (PackedScene) var SludgeRat

var player = null

onready var spawn_timer = $SpawnTimer

func set_player(_player):
	player = _player
	set_difficulty(player.score)
	player.connect("score_changed", self, "set_difficulty")

func spawn_enemy(enemy, direction_facing = 0):
	var enemy_instance = enemy.instance()
	call_deferred("add_child", enemy_instance)
	enemy_instance.set_player(player)
	enemy_instance.set_enemy_spawner(self)
	if enemy_instance.has_method("set_direction_facing") && direction_facing != 0:
		enemy_instance.set_direction_facing(direction_facing)

func spawn_enemies(enemy, amount = 1, delay = 0, direction_facing = 0):
	for i in range(amount):
		var timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", timer, "queue_free")
		timer.connect("timeout", self, "spawn_enemy", [enemy, direction_facing])
		timer.set_wait_time(delay * i + 0.001)
		timer.start()

func spawn_random_enemy():
	var roll = randf()
	if roll < 0.5:
		spawn_enemy(Rat)
	elif roll < 0.75:
		spawn_enemies(Rat, 3, 0.5, 1 if randf() > 0.5 else -1)
	else:
		spawn_enemy(Bat)

func handle_enemy_entered_sludge(enemy):
	if enemy.is_in_group("rat"):
		spawn_enemy(SludgeRat)
	elif enemy.is_in_group("bat"):
		spawn_enemy(Bat)

func set_difficulty(score):
	spawn_timer.wait_time = (max_spawn_time - min_spawn_time) * exp(-pow(difficulty_multiplier * score, 2)) + min_spawn_time

func _on_SpawnTimer_timeout():
	spawn_random_enemy()
