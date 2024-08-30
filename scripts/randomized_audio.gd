extends AudioStreamPlayer

var last_pitch = 0.8

func custom_play(audio_stream: AudioStream, from_position=0.0):
	stream = audio_stream  # Set the audio stream to be played
	randomize()
	pitch_scale = randf_range(0.8, 1.2) 
	
	while abs(pitch_scale - last_pitch) < 0.1:
		randomize()
		pitch_scale = randf_range(0.8, 1.2) 
	
	last_pitch = pitch_scale
	play(float(from_position))
