class_name State extends Node

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await self.get_parent().get_parent().ready
	player = self.get_parent().get_parent() as Player
	var test = 1


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
	
