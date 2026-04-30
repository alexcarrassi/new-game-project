class_name SettingsScreen extends Control

@onready var btn_exit: Button =  $MarginContainer/HBoxContainer/btn_Exit
@onready var slider_volume_master: Slider = $MarginContainer/Options/Controls_tab/Audio/HBoxContainer/slider_volume_master
@onready var slider_volume_music: Slider = $MarginContainer/Options/Controls_tab/Audio/HBoxContainer2/slider_volume_music
@onready var slider_volume_sfx: Slider = $MarginContainer/Options/Controls_tab/Audio/HBoxContainer3/slider_volume_sfx

@onready var p1_name: LineEdit = $MarginContainer/Options/Controls_tab/p1/VBoxContainer/PlayerNameLine/HBoxContainer/p1_name
@onready var p2_name: LineEdit = $MarginContainer/Options/Controls_tab/p2/VBoxContainer/PlayerNameLine2/HBoxContainer/p2_name

@onready var p1_colorpicker: Button = $MarginContainer/Options/Controls_tab/p1/VBoxContainer/ColorCustomization/ColorContainer/ColorPickerButton
@onready var p2_colorpicker: Button = $MarginContainer/Options/Controls_tab/p2/VBoxContainer/ColorCustomization2/ColorContainer/ColorPickerButton2

@onready var colorEditPanel: ColorEditPanel = $ColorEditPanel

@onready var colorPicker: ColorPicker = $ColorEditPanel/MarginContainer/VBoxContainer/ColorPicker
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

	print(PlayerCustomization.player_names)
	p1_name.text = PlayerCustomization.player_names[0]
	p2_name.text = PlayerCustomization.player_names[1]
	
	p1_name.text_changed.connect( func(new_text:String) -> void: 
		PlayerCustomization.player_names[0] = new_text
	)
	p2_name.text_changed.connect( func(new_text:String) -> void: 
		PlayerCustomization.player_names[1] = new_text
	)
	
	
	p1_colorpicker.pressed.connect( func() -> void:
		colorEditPanel.player_index = 0
		colorEditPanel.popup()	
	)
	
	p2_colorpicker.pressed.connect( func() ->void:
		colorEditPanel.player_index = 1
		colorEditPanel.popup()		
	)
	
	
	print(OS.get_user_data_dir())
	
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
