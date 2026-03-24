class_name None extends State

func enter(prev_state: State, data: Dictionary) -> void:
	pass
	
func physics_update(delta: float) -> void:

	var actor = self.body as Actor
	
	if(actor.intent.act != &""):
		print(actor.intent.act)
		self.finished.emit( actor.intent.act)
		actor.intent.clear_act()
	pass
