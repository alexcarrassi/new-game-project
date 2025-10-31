class_name zenchan_Running extends State



func enter(prev_state_path: String, data: Dictionary = {}) -> void:
	self.main_animation = "NORMAL/RUN"
	
	self.body.decision_timer.wait_time = self.body.DECISION_PERIOD
	self.body.decision_timer.start()
	pass


func physics_update(delta: float) -> void:
	
	var actor = self.body
	actor.velocity.y += actor.get_gravity().y * actor.GRAVITY_MULTIPLIER * delta
	actor.velocity.y = clamp(actor.velocity.y, -actor.MAX_RISE_VELOCITY, actor.MAX_FALL_VELOCITY)
	actor.velocity.x = actor.MAX_RUN_VELOCITY * actor.direction.x
	actor.move_and_slide()
	
	var position_compared_to_player = self.body.player_above()
	
	if( self.body.wall_ahead() ):
		self.body.flip()
		return
		
	if(self.body.decision_timer.time_left == 0):
		self.body.decision_timer.wait_time = self.body.DECISION_PERIOD
		self.body.decision_timer.start()

		if( position_compared_to_player == 1 and self.body.floor_above()) :
			self.finished.emit("JUMP_UP")
			
	

	if(! self.body.floor_front() and position_compared_to_player >= 0) :
		self.finished.emit("JUMP_FORWARD")
	elif(!self.body.is_on_floor()) :
		self.finished.emit("FALLING")	
		

	
func exit() -> void:
	self.body.decision_timer.stop()	
