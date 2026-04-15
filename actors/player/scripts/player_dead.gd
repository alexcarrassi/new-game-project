class_name Player_Dead extends State


# Called when the node enters the scene tree for the first time.
func enter(prev_state: State, data: Dictionary) -> void:
	var actor = self.body
	
	actor.sm_locomotion.physics_process_paused = true
	actor.sm_act.physics_process_paused = true
	actor.actorDeath.emit()

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
