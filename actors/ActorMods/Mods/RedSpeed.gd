class_name RedSpeed extends ActorMod
#generic speedboost

func activate(actor: Actor) -> void:
	actor.MAX_RUN_VELOCITY += 50
	
	pass
	
func deactivate(actor: Actor) -> void:
	actor.MAX_RUN_VELOCITY -= 50
	pass
