class_name PauseMenu extends Control

@onready var statTable_p1 = $MarginContainer/VBoxContainer/tab_Stats/MarginContainer/StatTable_P1
@onready var statTable_p2 = $MarginContainer/VBoxContainer/tab_Stats/MarginContainer2/StatTable_P2
@onready var cursor: TextureRect = $Cursor

@onready var tab_Pause = $MarginContainer/VBoxContainer2/MarginContainer/tab_Pause
@onready var btn_toGame = $MarginContainer/VBoxContainer2/MarginContainer/tab_Pause/btn_toGame
@onready var btn_toTitle = $MarginContainer/VBoxContainer2/MarginContainer/tab_Pause/btn_toTitle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	statTable_p1.playerEntry = Game.getPlayerEntry(0)
	statTable_p1.updateStats()
	statTable_p2.playerEntry = Game.getPlayerEntry(0)
	statTable_p2.updateStats()
	
	btn_toGame.pressed.connect( func() -> void: Game.resume_game() )
	btn_toTitle.pressed.connect( func() -> void: Game.exit_to_title()  )
	
	await get_tree().process_frame


	for node: Node in tab_Pause.get_children():
		if(node is Button) :
			node.focus_entered.connect( move_cursor_to.bind (node))
	
	btn_toGame.grab_focus()

	pass # Replace with function body.



func move_cursor_to( button: Button) -> void:
	
	cursor.visible = true 
	cursor.position = button.global_position
	cursor.position.x -= 20
	pass
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
