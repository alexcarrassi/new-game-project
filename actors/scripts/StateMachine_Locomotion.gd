class_name  StateMachine_Locomotion extends StateMachine

func _process( delta:float) -> void:
	var actor = self.get_parent() as Actor
	if( actor.loco_locked) :
		return
	
	super._process(delta)	

func _physics_process( delta: float) -> void:
	var actor = self.get_parent() as Actor
	if(actor.loco_locked) :
		return
		
	super._physics_process(delta)	
