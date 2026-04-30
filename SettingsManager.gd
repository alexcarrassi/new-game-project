class_name SettingsManager extends Node

const SETTINGS_PATH: String = "user://settings.cfg"

func load_settings() -> ConfigFile:
	var config: ConfigFile = ConfigFile.new()
	var err = config.load( SETTINGS_PATH )
	if(err != OK):
		printerr(err)
		
	apply_settings(config)
	return config
		
func save_settings() -> void:
	var config : ConfigFile = ConfigFile.new() 
	config = save_audio_settings(config)
	config = save_control_settings(config)
	config = save_customization_settings(config)

	var err = config.save( SETTINGS_PATH )
	if(err != OK):
		print(err)
		
		
func apply_audio_settings(config: ConfigFile) -> void:
	AudioServer.set_bus_volume_linear( AudioServer.get_bus_index("Master"), config.get_value("audio", "volume_master", 0.5)	 )
	AudioServer.set_bus_volume_linear( AudioServer.get_bus_index("Music"), config.get_value("audio", "volume_music", 1.0)	 )
	AudioServer.set_bus_volume_linear( AudioServer.get_bus_index("SFX"), config.get_value("audio", "volume_sfx", 1.0)	 )


func apply_control_settings(config: ConfigFile) -> void:
	
	var control_sections: Array[String] = ["controls_p1", "controls_p2"]
	
	for control_section: String in control_sections:
		
		var actions = config.get_section_keys(control_section)
		if actions == null:
			return
		
		for action in actions:
			var data: Dictionary = config.get_value(control_section, action, {})
			if( data.is_empty() ) :
				continue
			
			for oldEvent: InputEvent in InputMap.action_get_events( action ) :
				InputMap.action_erase_event( action, oldEvent)
				
			var type = data.get("type", "")
			var button = data.get("button", null)
			
			if (button == null || int(button) == 0) :
				continue
				
				
			match type:
				"key":
					var newEvent = InputEventKey.new()
					newEvent.keycode = button 
					InputMap.action_add_event(action, newEvent)
				"button":
					var newEvent = InputEventJoypadButton.new() 
					newEvent.button = button
					InputMap.action_add_event(action, newEvent)

func save_audio_settings(config: ConfigFile) -> ConfigFile:
	
	config.set_value("audio", "volume_master", AudioServer.get_bus_volume_linear( AudioServer.get_bus_index("Master")) )
	config.set_value("audio", "volume_music", AudioServer.get_bus_volume_linear( AudioServer.get_bus_index("Music")) )
	config.set_value("audio", "volume_sfx", AudioServer.get_bus_volume_linear( AudioServer.get_bus_index("SFX")) )

	return config




func save_control_settings(config: ConfigFile) -> ConfigFile:

	for action in InputMap.get_actions():
		match(action):
			"ui_left","ui_right","ui_start","attack","ui_jump", "ui_left_p2","ui_right_p2","ui_start_p2","attack_p2","ui_jump_p2":	

				var section_name = "controls_p2" if action.substr(action.length() - 2) == "p2" else "controls_p1"
				var events = InputMap.action_get_events(action)
				if(not  events.is_empty()):
					var event = events[0]
					var data: Dictionary = {
						"type": "",
						"button": "" 				
					}
					if(event is InputEventKey):
						data.type = "key"
						data.button = event.keycode
					else:
						data.type = "button"
						data.button = event.button_index	
					
					config.set_value(section_name, action, data)
				pass
	
	return config
	
func save_customization_settings(config: ConfigFile) -> ConfigFile:
	config.set_value("players", "p1_name", PlayerCustomization.player_names[0])
	config.set_value("players", "p2_name", PlayerCustomization.player_names[1])

	config.set_value("players", "p1_color_0", PlayerCustomization.player_colors[0][0])
	config.set_value("players", "p1_color_1", PlayerCustomization.player_colors[0][1])
	config.set_value("players", "p1_color_2", PlayerCustomization.player_colors[0][2])
	config.set_value("players", "p1_color_3", PlayerCustomization.player_colors[0][3])

	config.set_value("players", "p2_color_0", PlayerCustomization.player_colors[1][0])
	config.set_value("players", "p2_color_1", PlayerCustomization.player_colors[1][1])
	config.set_value("players", "p2_color_2", PlayerCustomization.player_colors[1][2])
	config.set_value("players", "p2_color_3", PlayerCustomization.player_colors[1][3])

	
	return config
	
func apply_customization_settings(config: ConfigFile) -> void:
	
	PlayerCustomization.player_names[0] = config.get_value("players", "p1_name", "Bub")
	PlayerCustomization.player_names[1] = config.get_value("players", "p2_name", "Bob")

	PlayerCustomization.player_colors[0][0] = config.get_value("players", "p1_color_0", Color.WHITE)
	PlayerCustomization.player_colors[0][1] = config.get_value("players", "p1_color_1", Color.WHITE)
	PlayerCustomization.player_colors[0][2] = config.get_value("players", "p1_color_2", Color.WHITE)
	PlayerCustomization.player_colors[0][3] = config.get_value("players", "p1_color_3", Color.WHITE)

	PlayerCustomization.player_colors[1][0] = config.get_value("players", "p2_color_0", Color.WHITE)
	PlayerCustomization.player_colors[1][1] = config.get_value("players", "p2_color_1", Color.WHITE)
	PlayerCustomization.player_colors[1][2] = config.get_value("players", "p2_color_2", Color.WHITE)
	PlayerCustomization.player_colors[1][3] = config.get_value("players", "p2_color_3", Color.WHITE)

	
	pass	
	
func apply_settings(config: ConfigFile) -> void:
	apply_audio_settings(config)
	apply_control_settings(config)
	apply_customization_settings(config)
	
	
