class_name HighscoreEntry_Control extends HBoxContainer

@onready var playerlabel: Label = $playerlabel
@onready var scorelabel: Label = $scoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setEntry( entry: HighscoreEntry) -> void:
	playerlabel.text = entry.playername
	scorelabel.text = str(entry.score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
