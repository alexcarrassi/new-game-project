class_name SkelMunsta_Idle extends State

func enter(prev_state_path: String, data: Dictionary) -> void:
	self.main_animation = "IDLE"
	
	get_tree().create_timer(2).timeout.connect( func() -> void:
		self.finished.emit( "HUNT")
	)
	
	
func physics_update(delta: float) -> void:
	pass
