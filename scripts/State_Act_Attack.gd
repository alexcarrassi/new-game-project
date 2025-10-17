class_name State_Attack extends State


func enter(prev_state_path: String, data: Dictionary ):
	
	
	print("Entering Attack")
	self.player.buffer_times['attack'] = 0

	var animationLock = AnimationLock.new( AnimationController.StatePriority.ACT, 20)
	self.animationController.request_oneShot("act/attack", animationLock)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func endAttack() -> void:
	print("GOING NONE")
	self.finished.emit("NONE")
