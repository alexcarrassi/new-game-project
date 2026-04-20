class_name SettingsScreen extends Control

@onready var btn_exit: Button =  $MarginContainer/HBoxContainer/btn_Exit
@onready var slider_volume_master: Slider = $MarginContainer/Options/HBoxContainer/slider_volume_master

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_exit.pressed.connect( 
		func() -> void: 
			Settings.save_settings()
			Game.exit_to_main_menu()
	)
	slider_volume_master.value_changed.connect( setMasterVolume )
	
	
	var master_volume = 0
	var master_bus_index = AudioServer.get_bus_index("Master")
	slider_volume_master.value = AudioServer.get_bus_volume_linear(master_bus_index)
	pass # Replace with function body.


func setMasterVolume(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus_index, value)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
