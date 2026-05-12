class_name Screen_Highscore extends Control

@export var highScore_spots: int = 10

@onready var container_highscores: VBoxContainer = $CenterContainer/MarginContainer/VBoxContainer/container_highscores

func _ready() -> void:
	load_highscores()

func load_highscores() -> void:
	for c in container_highscores.get_children():
		c.queue_free()
	
	var highscores: Array[HighscoreEntry] = HighScore.load_highscores()
	for entry: HighscoreEntry in highscores:
		var control: HighscoreEntry_Control = HighscoreEntry_Control.new() 
		control.setEntry(entry)
		container_highscores.add_child( control )
	
	pass
	
	
	
#Adds a new score entry. Returns the index of the newly added entry. -1 if not ranked.	
func add_score(score: Dictionary[String, int]) -> int:

	return -1
	pass
	

func save_highscores() -> void:
	
	
	pass	
	
