class_name Player_Dead extends State


# Called when the node enters the scene tree for the first time.
func enter(prev_state_path: String, data: Dictionary) -> void:
	var actor = self.body
	
	actor.loco_locked = true
	actor.act_locked = true
	actor.actorDeath.emit(actor)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
