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
	
	
func enter(prev_state: State, data: Dictionary = {}) -> void:
	var actor = self.body

	actor.collisionShape.disabled = false
	actor.sm_locomotion.physics_process_paused = false
	actor.sm_act.physics_process_paused = false
	
	pass
