class_name zenchan_JumpUp extends State

func enter(prev_state_path: String, data: Dictionary = {} ) -> void:
	self.body.velocity.y = -self.body.JUMP_VELOCITY
	self.body.velocity.x = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.main_animation = "NOMRAL/JUMP_UP"
	pass # Replace with function body.


func physics_update(delta: float) -> void:
	
	self.body.velocity.y -= self.body.get_gravity().y * delta 
	self.body.velocity.y = clamp( self.body.velocity.y, -self.body.MAX_RISE_VELOCITY, self.body.MAX_FALL_VELOCITY)
	
	self.body.move_and_slide()
	
	if(self.body.velocity.y <= 0) :
		self.finished.emit("FALLING")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
