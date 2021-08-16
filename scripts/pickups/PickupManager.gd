extends Node

export (PackedScene) var Crate
export (float) var min_spawn_distance = 128

onready var crate_spawn_locations = $CrateSpawnLocations
var player = null

func _ready():
	randomize()

func set_player(_player):
	player = _player
	spawn_crate()

func spawn_crate():
	var cells = crate_spawn_locations.get_used_cells()
	var valid_spawn_locations = []
	for cell in crate_spawn_locations.get_used_cells():
		var spawn_location = crate_spawn_locations.map_to_world(cells[randi() % cells.size()]) + crate_spawn_locations.cell_size / 2
		if player && spawn_location.distance_to(player.global_position) < min_spawn_distance:
			continue
		valid_spawn_locations.append(spawn_location)
	if valid_spawn_locations.size() <= 0:
		push_error("No valid spawn locations for crate, maybe the minimum spawn distance is too high")
	else:
		var crate = Crate.instance()
		call_deferred("add_child", crate)
		crate.global_position = valid_spawn_locations[randi() % valid_spawn_locations.size()]
		crate.set_pickup_manager(self)

func handle_crate_pickup():
	spawn_crate()
