class_name Actor_Spawning extends State


func ready() -> void:
	self.main_animation = "hurt"
	
func enter(prev_state: State, data: Dictionary = {}) -> void:
	var actor = self.body

	actor.collisionShape.disabled = true
	actor.hurtbox.monitorable = false
	actor.hurtbox.monitoring = false
	
	actor.sm_locomotion.physics_process_paused = true
	actor.sm_act.physics_process_paused = true
	
	pass
	
func exit() -> void:
	var actor = self.body
	actor.hurtbox.monitorable = true
	actor.hurtbox.monitoring = true
	pass	
