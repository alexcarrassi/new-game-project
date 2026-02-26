class_name Stact_act_None_Player extends State_act_None


func physics_update(delta: float) -> void:
		
	var inputState = body.inputState	
	if (body.buffer_times['attack'] > 0.0 ):
		var transition_data = { 
			"domain" : "act",
		}
		self.finished.emit("ATTACK", transition_data)
	
	
