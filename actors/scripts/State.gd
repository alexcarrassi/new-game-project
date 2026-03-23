class_name State extends Node

var body: Actor
var animationController: AnimationController
@export var main_animation : String
@export var allowed_states : Array[State] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# For outside effects only
func enterEffects() -> Array:
	return []
	
func exitEffects() -> Array:
	return []

func enter(prev_state: State, data: Dictionary) -> void :
	pass
	
func exit() -> void:
	pass
func can_enter(newState: State) -> bool: 
	return newState in allowed_states


func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass	

func handle_input(event: InputEvent) -> void: 
	pass
				
signal finished(next_state_path: String, data: Dictionary)
	
