class_name Petrify extends ActorMod

func _init() -> void:
	self.timeActive = 2
	self.mod_id = &"Petrified"

func activate(actor: Actor) -> void:
	
	print("petrifying %s" %[actor.name])
	actor.sm_status.state.finished.emit("PETRIFIED")
	


func deactivate(actor: Actor) -> void:
	print("unpetrifying %s" %[actor.name])
	actor.sm_status.state.finished.emit("ALIVE")
	
	
func tick_physics(delta: float, actor: Actor) -> void:
	pass
	
	
func tick_process(delta: float, actor: Actor) -> void:
	pass
	
