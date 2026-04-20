class_name SettingsManager extends Node

const SETTINGS_PATH: String = "user://settings.cfg"

var volume_master : float = 1.0 

func load_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	var err = config.load( SETTINGS_PATH )
	if(err != OK):
		apply_settings()
		
	volume_master = config.get_value("audio", "volume_master", 1.0)	
	apply_settings()
	pass
		
func save_settings() -> void:
	var config : ConfigFile = ConfigFile.new() 
	
	var volume_master = AudioServer.get_bus_volume_linear( AudioServer.get_bus_index("Master"))
	config.set_value("audio", "volume_master", volume_master )
	var err = config.save( SETTINGS_PATH )
	if(err != OK):
		print(err)

func apply_settings() -> void:
	AudioServer.set_bus_volume_linear( AudioServer.get_bus_index("Master"), volume_master )
	
