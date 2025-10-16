class_name State_Locomotion_Running extends State


func enter(previous_state_path: String, data: Dictionary) -> void:
	self.player.animationPlayer.play("movement/run")


func physics_update(delta: float) -> void:
	var target_speed = self.inputState.haxis * self.player.max_run_speed
	var runRate = self.ground_accel if (abs(self.player.inputState.haxis) > 0.0) else self.player.ground_decel
	
	#turnBoos
	if(target_speed * runRate < 0.0):
		runRate *= 3
	
	self.player.velocity.x = move_toward(self.player.velocity.x, target_speed, runRate)
	

	self.player.velocity.y += self.player.get_gravity().y * self.player.gravity_multiplier * delta
	self.player.velocity.y = clamp(self.velocity.y, -self.player.max_rise_speed, self.player.max_fall_speed)
	
			#move and slide
	self.player.move_and_slide()
	
		#read facts and state transition
	if not( self.player.is_on_floor() ) :
		self.finished.emit("FALLING")
	elif ( self.player.buffers["jump"] > 0.0):
		self.finished.emit("JUMPING")
	
	elif (abs(self.player.velocity.x) == 0) :
		self.finished.emit("IDLE")	
		
	
