class_name zenchan_Falling extends State


func enter(prev_state_path: String, data: Dictionary = {}) -> void:
	self.body.velocity.x = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.main_animation = "NORMAL/FALL"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float) -> void:
	var actor = self.body
	
	actor.velocity.y += actor.get_gravity().y * actor.gravity_multiplier * delta
	actor.velocity.y = clamp(actor.velocity.y, -actor.MAX_RISE_VELOCITY, actor.MAX_FALL_VELOCITY)
	
	actor.move_and_slide()
	
	if( actor.is_on_floor()): 
		print("Am on floor, from falling")
		self.finished.emit("RUNNING")
	pass
