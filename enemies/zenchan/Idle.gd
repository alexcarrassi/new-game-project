class_name zenchan_Idle extends State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.main_animation = "NORMAL/IDLE"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func physics_process( delta: float) -> void:
	self.body.velocity.y -= self.body.get_gravity().y *  self.body.gravity_multiplier * delta
	self.body.velocity.y = clamp(self.body.elocity.y, -self.MAX_RISE_VELOCITY, self.MAX_FALL_VELOCITY)
