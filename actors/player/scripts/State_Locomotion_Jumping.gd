class_name State_Locootion_Jumping extends State

func _ready() -> void:
		self.main_animation = "movement/jump_rise"

func enterEffects() -> Array:
		return [
		{
			"oneshot": { 
				"animation" : "movement/jump_rise_start",
				"prio"		: AnimationController.StatePriority.ACT
			}
		}
	]	

func enter(previous_state_path: String, data: Dictionary) -> void:
	
	self.body.velocity.y = -self.body.JUMP_VELOCITY
	#consume coyote and jump buffer
	self.body.buffer_times["jump"] = 0
	self.body.coyote_time = 0
	
func physics_update(delta: float) -> void:
	
	var body = self.body
	var inputState = body.inputState
	
	var targetSpeed = body.MAX_RUN_VELOCITY * inputState.haxis
	var moveRate = body.air_accel if (abs(inputState.haxis) > 0.0) else body.air_decel
	
	if( targetSpeed * moveRate < 0.0) :
		moveRate *= 3
		
	body.velocity.x = move_toward( body.velocity.x, targetSpeed, moveRate)	

	body.velocity.y += body.get_gravity().y * body.GRAVITY_MULTIPLIER_RISING * delta
	body.velocity.y = clamp(body.velocity.y, -body.MAX_RISE_VELOCITY, body.MAX_FALL_VELOCITY)
	
	body.move_and_slide()
	
	
	if( self.body.velocity.x != 0):
		self.body.sprite2D.flip_h = body.velocity.x < 0.0
	
	if(body.velocity.y > 0.0):
		self.finished.emit("FALLING")
	pass	
