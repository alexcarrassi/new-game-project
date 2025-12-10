class_name HURT extends State


func enter(prev_state_path: String, data: Dictionary) -> void:
	var actor = self.body 
	actor.loco_locked = true
	actor.act_locked = true 
	actor.hurtbox.set_collision_mask_value(3, false)
	
	var hurtLength = actor.animationPlayer.get_animation("hurt").length
	var animationLock = AnimationLock.new( 20, hurtLength, 3 )
	
	actor.animationPlayer.request_oneShot("hurt", animationLock)
	
	animationLock.lockReleased.connect( 
		func() -> void: 
			
			actor.health -= 1
			if(actor.health < 0):
				actor.health = 0
				self.finished.emit("DEAD")
			else :	
				self.finished.emit("ALIVE")
	)	
	
	#play the hurt animation
	#disable Hurtbox for the duration of the animation
	
	
func exit() -> void:
	var actor = self.body 
	actor.actorHurt.emit( actor )

	actor.loco_locked = false 	
	actor.act_locked = false
	actor.hurtbox.set_collision_mask_value(3, true)
	
	actor.modController.addMod(Invulnerability.new() )
 

func _ready() -> void:
	
	pass # Replace with function body.
