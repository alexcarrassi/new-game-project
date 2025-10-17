class_name State_Locootion_Jumping extends State

func _ready() -> void:
		self.main_animation = "movement/jump_rise"


func enter(previous_state_path: String, data: Dictionary) -> void:
	self.animationController.request_oneShot("movement/jump_rise_start")
	
	self.player.velocity.y = -self.player.jump_force
	
	#consume coyote and jump buffer
	self.player.buffer_times["jump"] = 0
	self.player.coyote_time = 0
	
func physics_update(delta: float) -> void:
	
	var player = self.player
	var inputState = player.inputState
	
	var targetSpeed = player.max_run_speed * inputState.haxis
	var moveRate = player.air_accel if (abs(inputState.haxis) > 0.0) else player.air_decel
	
	if( targetSpeed * moveRate < 0.0) :
		moveRate *= 3
		
	player.velocity.x = move_toward( player.velocity.x, targetSpeed, moveRate)	

	player.velocity.y += player.get_gravity().y * player.gravity_multiplier_rising * delta
	player.velocity.y = clamp(player.velocity.y, -player.max_rise_speed, player.max_fall_speed)
	
	player.move_and_slide()
	
	
	if( self.player.velocity.x != 0):
		self.player.sprite2D.flip_h = player.velocity.x < 0.0
	
	if(player.velocity.y > 0.0):
		self.finished.emit("FALLING")
	pass	
