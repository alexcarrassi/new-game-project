class_name zenchan_Idle extends State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.main_animation = "NORMAL/IDLE"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass
	
func physics_update( delta: float) -> void:
	self.body.velocity.y += self.body.get_gravity().y *  self.body.GRAVITY_MULTIPLIER * delta
	self.body.velocity.y = clamp(self.body.velocity.y, -self.body.MAX_RISE_VELOCITY, self.body.MAX_FALL_VELOCITY)
	
	
	self.body.move_and_slide()
	
	if not( self.body.is_on_floor()) :
		self.finished.emit("FALLING")

	
