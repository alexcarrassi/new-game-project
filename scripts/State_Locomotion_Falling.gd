class_name State_Locomotion_Falling extends State


func _ready() -> void:
	self.main_animation = "movement/jump_fall"
	
func enterEffects() -> Array:
	return [
		{
			"oneshot" : {
				"animation" : "movement/jump_fall_start",
				"prio" : AnimationController.StatePriority.ACT
			}
		}	
	]
	
func enter(previous_state_path: String, data: Dictionary) -> void:
		pass

func physics_update(delta: float) -> void:

	var inputState = self.body.inputState
	
	#horizontal movement
	var targetSpeed = inputState.haxis * self.body.max_run_speed 
	var moveRate = self.body.air_accel if(abs(inputState.haxis) > 0.0) else self.body.air_decel
	if (targetSpeed * moveRate  > 0.0):
		moveRate *= 3
		
	self.body.velocity.x = move_toward(self.body.velocity.x, targetSpeed, moveRate)
	
	self.body.velocity.y += self.body.get_gravity().y * self.body.gravity_multiplier_falling * delta
	self.body.velocity.y = clamp(self.body.velocity.y, -self.body.max_rise_speed, self.body.max_fall_speed)
	
	self.body.move_and_slide()
	
	
	self.body.coyote_time -= delta 
	self.body.coyote_time = max( 0, self.body.coyote_time - delta)
	
	if( self.body.velocity.x != 0):
		self.body.sprite2D.flip_h = body.velocity.x < 0.0

	
	if(self.body.is_on_floor()) :
		if(abs(inputState.haxis) > 0.0):   # i dont think this is correct
			self.finished.emit("RUNNING")
		else:
			self.finished.emit("IDLE")
	else:
		if( self.body.coyote_time > 0.0 and self.body.buffer_times['jump'] > 0.0) :
			self.finished.emit("JUMPING")		
