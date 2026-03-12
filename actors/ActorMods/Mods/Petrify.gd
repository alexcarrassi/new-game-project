class_name Petrify extends ActorMod

func _init() -> void:
	self.timeActive = 6
	self.mod_id = &"Petrified"

func activate(actor: Actor) -> void:
	
	print("petrifying %s" %[actor.name])
	
	actor.loco_locked = true 
	actor.act_locked = true 
	
	actor.animationPlayer.current_state_animation = "PETRIFIED"
	


func deactivate(actor: Actor) -> void:
	print("unpetrifying %s" %[actor.name])

	actor.loco_locked = false 
	actor.act_locked = false 
	actor.animationPlayer.current_state_animation = actor.sm_locomotion.state.main_animation
func tick_physics(delta: float, actor: Actor) -> void:
	pass
	
	
func tick_process(delta: float, actor: Actor) -> void:
	pass
	
