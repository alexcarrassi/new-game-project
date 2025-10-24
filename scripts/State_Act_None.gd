class_name State_act_None extends State

func enter(prev_state_path: String, data: Dictionary) -> void:
	print("Entering NONE")
	
func physics_update(delta: float) -> void:
	
	var inputState = self.body.inputState
		
	if (self.body.buffer_times['attack'] > 0.0):
		var transition_data = { 
			"domain" : "act",
		}
		self.finished.emit("ATTACK", transition_data)
	
