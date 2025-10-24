class_name State_Locomotion_Running extends State

func _ready() -> void:
	self.main_animation = "movement/run"

func enter(previous_state_path: String, data: Dictionary) -> void:
	self.body.coyote_time = self.body.coyote_max


func physics_update(delta: float) -> void:
	var target_speed = self.body.inputState.haxis * self.body.max_run_speed
	var runRate = self.body.ground_accel if (abs(self.body.inputState.haxis) > 0.0) else self.body.ground_decel
	
	#turnBoos
	if(target_speed * runRate < 0.0):
		runRate *= 3
	
	self.body.velocity.x = move_toward(self.body.velocity.x, target_speed, runRate)
	

	self.body.velocity.y += self.body.get_gravity().y * self.body.gravity_multiplier * delta
	self.body.velocity.y = clamp(self.body.velocity.y, -self.body.max_rise_speed, self.body.max_fall_speed)
	
			#move and slide
	self.body.move_and_slide()
	
		#read facts and state transition
		
		
	if (self.body.velocity.x != 0) :	
		self.body.sprite2D.flip_h =  self.body.velocity.x < 0.0	

		
	if not( self.body.is_on_floor() ) :
		self.finished.emit("FALLING")
	elif ( self.body.buffer_times["jump"] > 0.0):
		self.finished.emit("JUMPING")
	elif (abs(self.body.velocity.x) == 0) :
		self.finished.emit("IDLE")	
		
	
