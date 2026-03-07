class_name WorldWrapper extends Control

@export var debugMode: bool = false
@export var gameWorld: PackedScene
@export var statTable: PackedScene
@onready var subViewportContainer = $HBoxContainer/SubViewportContainer
@onready var debugPanel: PanelContainer = $HBoxContainer/PanelContainer_debug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var game = gameWorld.instantiate() as GameWorld 
	
	Game.playerRegistered.connect( createStatTable)

	subViewportContainer.add_child(game)
	var game_base := Vector2i(256, 256)
	var win := get_window()

	var canvas_size := game_base

	if(debugMode) :
		debugPanel.visible = true
		canvas_size.x += 256
	win.content_scale_size = canvas_size


	pass # Replace with function body.

func createStatTable(playerEntry: PlayerEntry) -> void:
	var table = statTable.instantiate()
	table.playerEntry = playerEntry
	debugPanel.add_child( table )
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
