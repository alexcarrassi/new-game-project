class_name Spawning extends State

func read() -> void:
	self.main_animation = "state/hurt"

func enter(prev_state_path: String, data: Dictionary) -> void:
	var actor = self.body
	actor.collisionShape.disabled
	actor.loco_locked = true 
	actor.act_locked = true
	pass
	
	
