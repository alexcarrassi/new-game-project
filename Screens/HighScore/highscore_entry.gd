class_name HighscoreEntry_Control extends HBoxContainer

@onready var playerlabel: Label = $HBoxContainer/playerlabel
@onready var scorelabel: Label = $HBoxContainer/scorelabel
@onready var animationPLayer: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setEntry( index: int, entry: HighscoreEntry) -> void:
	playerlabel.text = str(index + 1) + " " + entry.playername
	scorelabel.text = str(entry.score)
	
	if(!entry.is_saved):
		#this entry was not saved previously, so this is a new one.
		animationPLayer.play("flash_new")
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
