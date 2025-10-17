class_name State_Locomotion_Falling extends State


func _ready() -> void:
	self.main_animation = "movement/jump_fall"
	
func enter(previous_state_path: String, data: Dictionary) -> void:
	self.animationController.request_oneShot("movement/jump_fall_start")

	
	if(previous_state_path == "State_Locomotion_Idle"):
		pass

func physics_update(delta: float) -> void:

	var inputState = self.player.inputState
	
	#horizontal movement
	var targetSpeed = inputState.haxis * self.player.max_run_speed 
	var moveRate = self.player.air_accel if(abs(inputState.haxis) > 0.0) else self.player.air_decel
	if (targetSpeed * moveRate  > 0.0):
		moveRate *= 3
		
	self.player.velocity.x = move_toward(self.player.velocity.x, targetSpeed, moveRate)
	
	self.player.velocity.y += self.player.get_gravity().y * self.player.gravity_multiplier_falling * delta
	self.player.velocity.y = clamp(self.player.velocity.y, -self.player.max_rise_speed, self.player.max_fall_speed)
	
	self.player.move_and_slide()
	
	
	self.player.coyote_time -= delta 
	self.player.coyote_time = max( 0, self.player.coyote_time - delta)
	
	if( self.player.velocity.x != 0):
		self.player.sprite2D.flip_h = player.velocity.x < 0.0

	
	if(self.player.is_on_floor()) :
		if(abs(inputState.haxis) > 0.0):   # i dont think this is correct
			self.finished.emit("RUNNING")
		else:
			self.finished.emit("IDLE")
	else:
		if( self.player.coyote_time > 0.0 and self.player.buffer_times['jump'] > 0.0) :
			self.finished.emit("JUMPING")		
