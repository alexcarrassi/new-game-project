class_name Player_Spawning extends State

func enter(prev_state_path: String, data: Dictionary) -> void:
	var actor = self.body
	self.main_animation = "state/hurt"

	actor.collisionShape.disabled = true
	actor.loco_locked = true 
	actor.act_locked = true
	
	pass
	
func exit() -> void:
	var actor = self.body
	actor.loco_locked = false 
	actor.act_locked = false 
	actor.collisionShape.disabled = false	
