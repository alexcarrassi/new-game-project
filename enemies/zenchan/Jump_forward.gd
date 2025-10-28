class_name zenchan_jumpForward extends State


func enter(prev_state_path: String, data: Dictionary = {} ) -> void:
	self.body.velocity.x = self.body.RUN_SPEED * self.body.direction.x
	self.body.velocity.y = -self.body.JUMP_VELOCITY + 50.0
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func physics_update(delta: float) -> void:
	self.body.velocity.y += self.body.get_gravity().y * delta
	self.body.velocity.y = clamp( self.body.velocity.y, -self.body.MAX_RISE_VELOCITY, self.body.MAX_FALL_VELOCITY)
	
	self.body.move_and_slide()
	
	if(self.body.is_on_floor()) :
		self.finished.emit("RUNNING")
