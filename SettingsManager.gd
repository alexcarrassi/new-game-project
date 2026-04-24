class_name SettingsManager extends Node

const SETTINGS_PATH: String = "user://settings.cfg"

func load_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	var err = config.load( SETTINGS_PATH )
	if(err != OK):
		printerr(err)
		
	apply_settings(config)
	pass
		
func save_settings() -> void:
	var config : ConfigFile = ConfigFile.new() 
	config = save_audio_settings(config)
	config = save_control_settings(config)

	var err = config.save( SETTINGS_PATH )
	if(err != OK):
		print(err)
		
		
func apply_audio_settings(config: ConfigFile) -> void:
	var volume_master = config.get_value("audio", "volume_master", 1.0)	
	AudioServer.set_bus_volume_linear( AudioServer.get_bus_index("Master"), volume_master )


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
	
	var current_volume_master = AudioServer.get_bus_volume_linear( AudioServer.get_bus_index("Master"))
	config.set_value("audio", "volume_master", current_volume_master )

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
	
	
func apply_settings(config: ConfigFile) -> void:
	apply_audio_settings(config)
	apply_control_settings(config)
	
