class_name MainMenu extends Control
@onready var btn_newGame = $CenterContainer/VBoxContainer/btn_New_Game
@onready var btn_Exit = $CenterContainer/VBoxContainer/btn_Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	btn_newGame.pressed.connect( func() -> void: Game.start_new_game() )
	btn_Exit.pressed.connect( func() -> void: Game.exit()  )
	
	
	
	btn_newGame.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
