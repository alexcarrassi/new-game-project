class_name zenchan_jumpForward extends State


func enter(prev_state: State, data: Dictionary = {} ) -> void:
	self.body.velocity.x = self.body.MAX_RUN_VELOCITY * self.body.direction.x
	self.body.velocity.y = -self.body.JUMP_VELOCITY + 20.0
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func physics_update(delta: float) -> void:
	self.body.velocity.y += self.body.get_gravity().y * delta
	self.body.velocity.y = clamp( self.body.velocity.y, -self.body.MAX_RISE_VELOCITY + 20, self.body.MAX_FALL_VELOCITY)
	
	self.body.move_and_slide()
	
	
	if( self.body.wall_ahead() ):
		self.body.flip()
		self.body.velocity.x = self.body.MAX_RUN_VELOCITY * self.body.direction.x

		
	#var collision_count = body.get_slide_collision_count()
	#for i in range(collision_count):
		#var collision = body.get_slide_collision(i)
		#var collision_normal = collision.get_normal()
		#
		#if(abs(collision_normal.x) > 0 ):
			#print('flip')
			#body.direction.x = collision_normal.x
			#body.velocity.x *= -1
	
	if(self.body.is_on_floor()) :
		self.finished.emit("RUNNING")
