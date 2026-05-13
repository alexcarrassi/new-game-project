class_name Screen_Highscore extends Control

@export var highScore_spots: int = 10

@onready var container_highscores: VBoxContainer = $MarginContainer/VBoxContainer/MarginContainer2/container_highscores
@onready var btn_toTitle: Button = $MarginContainer2/VBoxContainer2/MarginContainer/tab/btn_toTitle

var HighscoreEntry_ControlScene: PackedScene = load("res://Screens/HighScore/HighscoreEntry.tscn")

func _ready() -> void:
	load_highscores()
	
	btn_toTitle.pressed.connect( func() -> void: Game.exit_to_main_menu() )

func load_highscores() -> void:

	for c in container_highscores.get_children():
		c.queue_free()
	
	var highscores: Array[HighscoreEntry] = HighScore.load_highscores()
	for i: int in range(highscores.size()) :
		var control: HighscoreEntry_Control = HighscoreEntry_ControlScene.instantiate()
		container_highscores.add_child( control )
		var entry: HighscoreEntry = highscores[i]
		control.setEntry(i, entry)
		
		

	

	
