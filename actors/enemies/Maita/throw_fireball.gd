class_name Throw_Fireball extends State

@export var FireballScene: PackedScene

func enter(prev_state_path: String, transition_data: Dictionary) -> void:
	#pause. 
	#instantiate fireball in dir with speed
	#exit 
	
	
	var actor =  self.body
	actor.loco_locked = true
	actor.act_locked = true
	
	
	await get_tree().create_timer(1).timout
	var fireball = self.FireballScene.instantiate() as Fireball
	fireball.dir = actor.direction
	fireball.speed = actor.MAX_RUN_VELOCITY * 1.1
	Game.world.level.add_child( fireball )
	
	self.emit.finished("NONE")
	pass
	
func exit() -> void:
	var actor = self.body
	actor.loco_locked = false 
	actor.act_locked = false
	
	
	
	
	
