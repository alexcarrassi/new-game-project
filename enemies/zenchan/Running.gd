class_name zenchan_Running extends State



func enter(prev_state_path: String, data: Dictionary = {}) -> void:
	self.main_animation = "NORMAL/RUN"

	pass
	#self.animationController.play("NORMAL/RUN")


func physics_update(delta: float) -> void:
	
	var actor = self.body
	actor.velocity.y += actor.get_gravity().y * actor.gravity_multiplier * delta
	actor.velocity.y = clamp(actor.velocity.y, -actor.MAX_RISE_VELOCITY, actor.MAX_FALL_VELOCITY)
	
	actor.velocity.x = actor.RUN_SPEED * actor.direction.x
	
	actor.sprite2D.flip_h = actor.velocity.x > 0.0
	
	actor.move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
