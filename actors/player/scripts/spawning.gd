class_name Player_Suspended extends State

func enter(prev_state: State, data: Dictionary) -> void:
	var actor = self.body as Player
	self.main_animation = "Suspended"

	actor.collisionShape.disabled = true
	actor.sm_locomotion.physics_process_paused = true 
	actor.sm_act.physics_process_paused = true
	

	pass	
	
func exit() -> void:
	var actor = self.body
	actor.sm_locomotion.physics_process_paused = false 
	actor.sm_act.physics_process_paused = false 
	actor.collisionShape.disabled = false	
