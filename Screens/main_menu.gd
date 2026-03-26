class_name MainMenu extends Control
@onready var btn_newGame = $CenterContainer/VBoxContainer/btn_New_Game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	btn_newGame.pressed.connect( func() -> void: Game.start_new_game() )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
