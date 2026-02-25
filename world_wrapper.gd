class_name WorldWrapper extends Control

@export var debugMode: bool = false
@export var gameWorld: PackedScene
@onready var subViewportContainer = $HBoxContainer/SubViewportContainer
@onready var debugPanel: PanelContainer = $HBoxContainer/PanelContainer_debug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var game = gameWorld.instantiate() as GameWorld 
	subViewportContainer.add_child(game)
	var game_base := Vector2i(256, 256)
	var win := get_window()

	var canvas_size := game_base

	if(debugMode) :
		
		debugPanel.visible = true
		canvas_size.x += 256


	win.content_scale_size = canvas_size


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
