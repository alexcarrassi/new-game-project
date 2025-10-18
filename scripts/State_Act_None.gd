class_name State_act_None extends State

func enter(prev_state_path: String, data: Dictionary) -> void:
	print("Entering NONE")
	
func physics_update(delta: float) -> void:
	
	var inputState = self.player.inputState
		
	if (self.player.buffer_times['attack'] > 0.0):
		self.finished.emit("ATTACK")
	
