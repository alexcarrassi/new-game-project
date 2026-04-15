class_name AudioBank extends Node

@onready var channel_action: AudioStreamPlayer2D = $channel_action
@onready var channel_locomotion: AudioStreamPlayer2D = $channel_locomotion
@onready var channel_status: AudioStreamPlayer2D = $channel_status

@export var sfx: Dictionary[StringName, AudioStream]


func _ready() -> void:
	#listen to the events from the actor
	pass

func get_channel(channel_name: StringName) -> AudioStreamPlayer2D:
	match(channel_name):
		&"locomotion":
			return channel_locomotion
		&"action":
			return channel_action
		&"status":
			return channel_status
		_:
			return channel_action
					
func get_sound(sound_name: StringName) -> AudioStream:
	return sfx.get(sound_name, null)

func play_sound(channel_name: StringName, sound_name: StringName) -> void:
	var channel = get_channel(channel_name)
	var sound = get_sound(sound_name)
	if(channel && sound):
		channel.stop()	
		channel.stream = sound
		channel.play()
		
	
	

	
