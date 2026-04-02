class_name Bubbled extends State


func enter(prev_state: State, data: Dictionary = {} ) -> void :
	
	print("BUBBLED")
	var actor = self.body
	var bubble: PlayerBubble = data.get("bubble") 


	# we default the P! Bubbled animation
	self.main_animation = "BUBBLED"


	if(bubble):
		if( bubble.ownerPlayer ):
			main_animation = "BUBBLED" if bubble.ownerPlayer.player_index == 0 else "BUBBLED_P2"
	
	actor.sm_locomotion.physics_process_paused = true
	actor.sm_act.physics_process_paused = true 
	
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
	actor.sm_locomotion.physics_process_paused = false
	actor.sm_act.physics_process_paused = false 
	

	
	
	
