class_name Actor_Spawning extends State


func ready() -> void:
	self.main_animation = "hurt"
	
func enter(prev_state_path: String, data: Dictionary = {}) -> void:
	var actor = self.body

	actor.collisionShape.disabled = true
	actor.loco_locked = true
	actor.act_locked = true
	pass
	
func exit() -> void:
	pass	
