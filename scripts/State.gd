class_name State extends Node

var body: CharacterBody2D
var animationController: AnimationController
var main_animation : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# For outside effects only
func enterEffects() -> Array:
	return []
	
func exitEffects() -> Array:
	return []

func enter(prev_state_path: String, data: Dictionary) -> void :
	pass
	
func exit() -> void:
	pass

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass	

func handle_input(event: InputEvent) -> void: 
	pass
				
signal finished(next_state_path: String, data: Dictionary)
	
