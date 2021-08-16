extends Node

export (AudioStream) var Music

func _ready():
	play(Music, -8)

func play(audio_stream, volume = 0, pitch = 1):
	if audio_stream:
		var audio_stream_player = AudioStreamPlayer.new()
		add_child(audio_stream_player)
		audio_stream_player.stream = audio_stream
		audio_stream_player.volume_db = volume
		audio_stream_player.pitch_scale = pitch
		audio_stream_player.play()
		audio_stream_player.connect("finished", audio_stream_player, "queue_free")
	else:
		push_error("No audio stream found")
