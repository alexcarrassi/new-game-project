class_name Invulnerability extends ActorMod



func activate(actor: Actor) -> void:
	print("Start invul")
	actor.hurtbox.monitoring = false 
	actor.hurtbox.monitorable = false 


func deactivate(actor: Actor) -> void:
	print("End invul")
	
	actor.hurtbox.monitoring = true 
	actor.hurtbox.monitorable = true 
	actor.sprite2D.visible = true
	
func tick_physics(delta: float, actor: Actor) -> void:
	pass
	
	
func tick_process(delta: float, actor: Actor) -> void:
	print("invuln " + actor.name)

	actor.sprite2D.visible = !actor.sprite2D.visible
	pass
	
