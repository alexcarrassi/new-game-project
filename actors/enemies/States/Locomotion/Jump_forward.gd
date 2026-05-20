class_name zenchan_jumpForward extends State
var jump_start_y: float = 0.0
var gravity_part_1: float = 1
var gravity_part_2 : float = 0.25


func enter(prev_state: State, data: Dictionary = {} ) -> void:
	self.body.velocity.x = self.body.MAX_RUN_VELOCITY * self.body.direction.x
	self.body.velocity.y = -self.body.JUMP_VELOCITY 
	
	jump_start_y = self.body.position.y
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func physics_update(delta: float) -> void:
	
	var grav_constant = gravity_part_1 if self.body.velocity.y < 0 else gravity_part_2
	
	self.body.velocity.y +=  (self.body.get_gravity().y * grav_constant ) * delta
	self.body.velocity.y = clamp( self.body.velocity.y, -self.body.MAX_RISE_VELOCITY + 20, self.body.MAX_FALL_VELOCITY)
	
	self.body.move_and_slide()
	
	
	if( self.body.wall_ahead() ):
		self.body.flip()
		self.body.velocity.x = self.body.MAX_RUN_VELOCITY *2* self.body.direction.x
		body.velocity = body.velocity.limit_length( body.MAX_RUN_VELOCITY)
		
		
	if(self.body.position.y >= jump_start_y):
		self.finished.emit("FALLING")	
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
