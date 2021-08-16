extends CanvasLayer

onready var container = $Container
onready var score = $Container/PanelContainer/MarginContainer/Rows/Score
onready var reset_cooldown = $ResetCooldown

func _ready():
	hide()

func _unhandled_input(event):
	if is_visible() && reset_cooldown.is_stopped():
		if event.is_action_pressed("ui_accept"):
			restart()
		elif event.is_action_pressed("ui_shoot"):
			var _error = get_tree().change_scene_to(Global.MAIN_MENU)

func hide():
	container.visible = false

func show():
	container.visible = true
	reset_cooldown.start()

func is_visible():
	return container.visible

func set_score(_score):
	var highscore = Global.load_score()
	if _score > highscore:
		score.text = "new highscore: " + str(_score) 
		Global.save_score(_score)
	else:
		score.text = "score: " + str(_score)

func restart():
	var _error = get_tree().change_scene_to(Global.GAME_SCENE)

func quit():
	get_tree().quit()
