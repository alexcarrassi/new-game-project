class_name State_Locomotion_Idle extends State


func _ready() -> void:
	self.main_animation = "movement/idle"

func enter(previous_state_path: String, data: Dictionary) -> void:
	player.coyote_time = player.coyote_max
	pass
	
#the physics update is also used for physics-based state transitions
func physics_update(delta: float) -> void:
	var player = self.player
	
	self.player.velocity.x = 0.0
		#Physics integration
	self.player.velocity.y += self.player.get_gravity().y * self.player.gravity_multiplier * delta
	self.player.velocity.y = clamp(self.player.velocity.y, -self.player.max_rise_speed, self.player.max_fall_speed)

		#move and slide
	self.player.move_and_slide()
	
	
	if( self.player.velocity.x != 0):
		self.player.sprite2D.flip_h = player.velocity.x < 0.0

	
		#read facts and state transition
	if not( self.player.is_on_floor() ) :
		self.finished.emit("FALLING")
	elif ( self.player.buffer_times["jump"] > 0.0):
		self.finished.emit("JUMPING")
	elif( abs( self.player.inputState.haxis) > 0.0 ):
		self.finished.emit("RUNNING")	
		
	#update coyote time	
			
	
