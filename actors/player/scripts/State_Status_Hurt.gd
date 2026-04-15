class_name HURT extends State


func enter(prev_state: State, data: Dictionary) -> void:
	var actor = self.body 
	actor.actorHurtStart.emit()
	actor.sm_locomotion.physics_process_paused = true
	actor.sm_act.physics_process_paused = true 

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
	actor.actorHurt.emit(  )

	actor.sm_locomotion.physics_process_paused = false 	
	actor.sm_act.physics_process_paused = false
	
	var invulnerability = Give_Invulnerability.new() 
	invulnerability.timeActive = 2
	actor.modController.addMod(invulnerability)
 

func _ready() -> void:
	
	pass # Replace with function body.
