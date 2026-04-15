class_name PauseMenu extends Control

@onready var statTable_p1 = $MarginContainer/VBoxContainer/tab_Stats/MarginContainer/StatTable_P1
@onready var statTable_p2 = $MarginContainer/VBoxContainer/tab_Stats/MarginContainer2/StatTable_P2

@onready var tab_Pause = $MarginContainer/VBoxContainer2/MarginContainer/tab_Pause
@onready var btn_toGame = $MarginContainer/VBoxContainer2/MarginContainer/tab_Pause/btn_toGame
@onready var btn_toTitle = $MarginContainer/VBoxContainer2/MarginContainer/tab_Pause/btn_toTitle

@export var pauseSound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	statTable_p1.playerEntry = Game.getPlayerEntry(0)
	statTable_p1.updateStats()
	statTable_p2.playerEntry = Game.getPlayerEntry(0)
	statTable_p2.updateStats()
	
	btn_toGame.pressed.connect( func() -> void: Game.resume_game() )
	btn_toTitle.pressed.connect( func() -> void: Game.exit_to_title()  )
	
	await get_tree().process_frame
	btn_toGame.grab_focus()
	
	Game.world.audioPlayer.stop() 
	if(pauseSound):
		Game.world.audioPlayer.stream = pauseSound
		Game.world.audioPlayer.play()

	pass # Replace with function body.

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
