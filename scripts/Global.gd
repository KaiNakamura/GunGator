extends Node

const TARGET_FPS = 60
const MAIN_MENU = preload("res://scenes/ui/MainMenu.tscn")
const GAME_SCENE = preload("res://scenes/Game.tscn")
const WHITE_SHADER = preload("res://shaders/white_shader.shader")
const SCORE_FILE = "user://score.save"

var white_shader_material = null

func _ready():
	white_shader_material = ShaderMaterial.new()
	white_shader_material.set_shader(WHITE_SHADER)

func save_score(score):
	var file = File.new()
	file.open(SCORE_FILE, File.WRITE)
	file.store_var(score)
	file.close()

func load_score():
	var file = File.new()
	var score = 0
	if file.file_exists(SCORE_FILE):
		file.open(SCORE_FILE, File.READ)
		score = file.get_var()
		file.close()
	return score
