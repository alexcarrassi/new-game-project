class_name zenchan_Running extends State



func enter(prev_state_path: String, data: Dictionary = {}) -> void:
	self.main_animation = "NORMAL/RUN"

	pass
	#self.animationController.play("NORMAL/RUN")


func _physics_process(delta: float) -> void:
	var body = self.body 
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
