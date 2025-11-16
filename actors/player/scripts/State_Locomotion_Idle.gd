class_name State_Locomotion_Idle extends State


func _ready() -> void:
	self.main_animation = "movement/idle"

func enter(previous_state_path: String, data: Dictionary) -> void:
	body.coyote_time = body.coyote_max
	pass
	
#the physics update is also used for physics-based state transitions
func physics_update(delta: float) -> void:
	var body = self.body
	
	self.body.velocity.x = 0.0
		#Physics integration
	self.body.velocity.y += self.body.get_gravity().y * self.body.GRAVITY_MULTIPLIER * delta
	self.body.velocity.y = clamp(self.body.velocity.y, -self.body.MAX_RISE_VELOCITY, self.body.MAX_FALL_VELOCITY)

		#move and slide
	self.body.move_and_slide()
	self.body.post_move_and_slide()

	
	if( self.body.velocity.x != 0):
		self.body.sprite2D.flip_h = body.velocity.x < 0.0

	
		#read facts and state transition
	if not( self.body.is_on_floor() ) :
		self.finished.emit("FALLING")
	elif ( self.body.buffer_times["jump"] > 0.0):
		self.finished.emit("JUMPING")
	elif( abs( self.body.inputState.haxis) > 0.0 ):
		self.finished.emit("RUNNING")	
		
	#update coyote time	
			
	
