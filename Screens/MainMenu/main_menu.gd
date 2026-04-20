class_name MainMenu extends Control
@onready var btn_newGame: Button = $CenterContainer/Options/btn_New_Game
@onready var btn_newGame_2p: Button = $CenterContainer/Options/btn_New_Game_2players
@onready var btn_Exit: Button = $CenterContainer/Options/btn_Exit
@onready var btn_Continue: Button = $CenterContainer/Options/btn_Continue
@onready var btn_Settings: Button = $CenterContainer/Options/btn_Settings
@onready var optionsContainer: VBoxContainer = $CenterContainer/Options

@onready var cursor: TextureRect = $Cursor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame

	btn_newGame.pressed.connect( func() -> void: Game.start_new_game({"gamestate": {"game_mode" : 0}}) )
	btn_newGame_2p.pressed.connect( func() -> void: Game.start_new_game( {"gamestate": {"game_mode" : 1}}))
	btn_Exit.pressed.connect( func() -> void: Game.exit()  )
	btn_Continue.pressed.connect( func() -> void: Game.continue_game() )
	btn_Settings.pressed.connect( func() -> void: Game.open_settings_menu())
	
	btn_newGame.grab_focus()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
