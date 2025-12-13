class_name Bubbled extends State


func enter(prev_state_path: String, data: Dictionary = {} ) -> void :
	
	print("BUBBLED")
	var actor = self.body
	self.main_animation = "BUBBLED"
	
	actor.loco_locked = true
	actor.act_locked = true 
	
	actor.hurtbox.call_deferred("set_monitorable", false)
	actor.collisionShape.set_deferred("disabled", true)
	pass
	
func exit() -> void:
	print("UNBUBBLED")
	var actor = self.body
	actor.hurtbox.call_deferred("set_monitorable", true)
	actor.collisionShape.set_deferred("disabled", false)

	#actor.set_collision_layer_value(7, false)
	#actor.set_collision_layer_value(3, true)	
	actor.loco_locked = false
	actor.act_locked = false 
	

	
	
	
