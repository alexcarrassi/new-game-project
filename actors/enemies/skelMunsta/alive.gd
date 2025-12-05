class_name SkelMunsta_Alive extends State



func enterEffects() -> Array:
	return [
		{
			"oneshot" : {
				"animation" : "SPAWN",
				"prio" : AnimationController.StatePriority.ACT
				
			}
		}	
	]
	
	
func enter(prev_state_path: String, data: Dictionary = {}) -> void:
	var actor = self.body

	actor.collisionShape.disabled = false
	actor.loco_locked = false
	actor.act_locked = false
	
	pass
