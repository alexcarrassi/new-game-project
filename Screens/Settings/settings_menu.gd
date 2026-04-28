class_name SettingsScreen extends Control

@onready var btn_exit: Button =  $MarginContainer/HBoxContainer/btn_Exit
@onready var slider_volume_master: Slider = $MarginContainer/Options/HBoxContainer/slider_volume_master
@onready var slider_volume_music: Slider = $MarginContainer/Options/HBoxContainer2/slider_volume_music
@onready var slider_volume_sfx: Slider = $MarginContainer/Options/HBoxContainer3/slider_volume_sfx

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_exit.pressed.connect( 
		func() -> void: 
			Settings.save_settings()
			Game.exit_to_main_menu()
	)
	slider_volume_master.value_changed.connect( setMasterVolume )
	slider_volume_music.value_changed.connect( setMusicVolume )
	slider_volume_sfx.value_changed.connect( setSFXVolume )

	
	slider_volume_master.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
	slider_volume_music.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music"))
	slider_volume_sfx.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX"))

	
	
	pass # Replace with function body.


func setMasterVolume(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus_index, value)
	pass
	
func setMusicVolume(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(bus_index, value)
	pass
	
func setSFXVolume(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_linear(bus_index, value)
	pass
	
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
