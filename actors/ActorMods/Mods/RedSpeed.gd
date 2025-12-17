class_name RedSpeed extends ActorMod
#generic speedboost

func _init() -> void:
	self.mod_id = &"REDSPEED"

func activate(actor: Actor) -> void:
	actor.MAX_RUN_VELOCITY += 75
	actor.DECISION_PERIOD -= 0.2
	print("ACTIVATE")

	pass
	
func deactivate(actor: Actor) -> void:
	actor.MAX_RUN_VELOCITY -= 75
	actor.DECISION_PERIOD += 0.2
	print("DEACTIVATE")
	pass
	
func tick_process(delta: float, actor: Actor) -> void:	
	print("RED")	
