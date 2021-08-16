extends CanvasLayer

onready var menu_buttons = $Container/Rows/MenuButtons
onready var high_score = $Container/Rows/TitleContainer/HighScore

func _ready():
	menu_buttons.get_child(0).grab_focus()
	for menu_button in menu_buttons.get_children():
		menu_button.audio_enabled = true
	high_score.text = "highscore: " + str(Global.load_score())

func _on_PlayButton_pressed():
	var _error = get_tree().change_scene_to(Global.GAME_SCENE)

func _on_QuitButton_pressed():
	get_tree().quit()
