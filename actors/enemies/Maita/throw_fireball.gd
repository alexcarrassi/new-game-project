class_name Throw_Fireball extends State

@export var FireballScene: PackedScene

func enter(prev_state_path: String, transition_data: Dictionary) -> void:

	var actor =  self.body
	actor.loco_locked = true
	actor.act_locked = true
	actor.decision_timer.stop()
	
	await get_tree().create_timer(1).timeout
	var fireball = actor.fireBallScene.instantiate() as Fireball
	fireball.dir = actor.direction
	fireball.speed = actor.MAX_RUN_VELOCITY * 1.1
	fireball.position = actor.position
	Game.world.level.add_child( fireball )
	
	actor.set_owned(&"Fireball", fireball)
	#actor.owns['fireball'] =fireball 
	self.finished.emit(&"State_act_None")
	#actor.intent.locomotion = &"RUNNING"
	pass
	
func exit() -> void:
	var actor = self.body
	actor.decision_timer.start()
	actor.loco_locked = false 
	actor.act_locked = false
	
	
	
	
	
