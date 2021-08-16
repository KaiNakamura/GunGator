tool
extends TextureButton

export (String) var text = "Text"
export (AudioStream) var FocusAudio
export (AudioStream) var SelectAudio

var audio_enabled = false

func _ready():
	setup_text()
	set_focus_mode(true)
	unhighlight()

func _process(_delta):
	if Engine.editor_hint:
		setup_text()

func setup_text():
	$Label.text = text

func highlight():
	set_bg_color(Color(0, 0, 0, 0.5))

func unhighlight():
	set_bg_color(Color(0, 0, 0, 0))

func set_bg_color(color):
	var new_stylebox_normal = $Label.get_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = color
	$Label.add_stylebox_override("normal", new_stylebox_normal)

func _on_MenuButton_focus_entered():
	highlight()
	if audio_enabled && FocusAudio:
		AudioManager.play(FocusAudio)

func _on_MenuButton_focus_exited():
	unhighlight()

func _on_MenuButton_mouse_entered():
	grab_focus()

func _on_MenuButton_pressed():
	if audio_enabled && SelectAudio:
		AudioManager.play(SelectAudio)
