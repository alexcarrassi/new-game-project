class_name Petrify extends ActorMod

func _init() -> void:
	self.timeActive = 6
	self.mod_id = &"Petrified"

func activate(actor: Actor) -> void:
	
	print("petrifying %s" %[actor.name])
	
	actor.sm_locomotion.physics_process_paused = true 
	actor.sm_locomotion.physics_process_paused = true 
	actor.sm_act.physics_process_paused = true 
	
	actor.animationPlayer.current_state_animation = "PETRIFIED"
	


func deactivate(actor: Actor) -> void:
	print("unpetrifying %s" %[actor.name])

	actor.sm_locomotion.physics_process_paused = false 
	actor.sm_act.physics_process_paused = false 
	actor.animationPlayer.current_state_animation = actor.sm_locomotion.state.main_animation
	
func tick_physics(delta: float, actor: Actor) -> void:
	pass
	
	
func tick_process(delta: float, actor: Actor) -> void:
	pass
	
