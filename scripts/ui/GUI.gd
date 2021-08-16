extends CanvasLayer

var player = null

onready var container = $Container
onready var score = $Container/Rows/TopRow/Score
onready var game_over_screen = $GameOverScreen

func _ready():
	container.visible = true

func set_player(_player):
	player = _player
	set_score(player.score)
	player.connect("score_changed", self, "set_score")
	player.connect("player_died", self, "handle_player_died")

func get_score():
	return int(score.text)

func set_score(_score):
	score.text = str(_score) 

func handle_player_died():
	score.visible = false
	game_over_screen.set_score(get_score())
	game_over_screen.show()
