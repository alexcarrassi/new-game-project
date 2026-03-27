class_name WorldWrapper extends Control

@export var debugMode: bool = false
@export var statTable: PackedScene
@onready var gameplayLayer = $HBoxContainer/GameArea/GameplayLayer
@onready var gameViewPort = $HBoxContainer/GameArea/GameplayLayer
@onready var debugLayer: Control = $HBoxContainer/DebugLayer
@onready var screenlayer: Control = $HBoxContainer/GameArea/ScreenLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#var mainMenu = Game.mainMenuScene.instantiate() as MainMenu
	#screenlayer.add_child( mainMenu )
	#
	#
	#
	var titleScreen = Game.titleScene.instantiate() as TitleScreen
	screenlayer.add_child( titleScreen )
	
	var game_base := Vector2i(256, 256)
	var win := get_window()
	var canvas_size := game_base

	Game.register_root(self)
	


	
	
	#if(debugMode) :
		#debugLayer.visible = true
		#canvas_size.x += 256
	#win.content_scale_size = canvas_size


	pass # Replace with function body.
	_fit_to_viewport()
	get_viewport().size_changed.connect(_fit_to_viewport)

func _fit_to_viewport() -> void:
	position = Vector2.ZERO
	size = get_viewport_rect().size
	
	
func createStatTable(playerEntry: PlayerEntry) -> void:
	var table = statTable.instantiate()
	table.playerEntry = playerEntry
	debugLayer.add_child( table )
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
