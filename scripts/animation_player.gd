class_name AnimationController extends AnimationPlayer

enum StatePriority{ STATUS = 20, ACT = 10, LOCOMOTION = 0 }

var lock := {}

var sm_locomotion : StateMachine_Locomotion
#var sm_act		  : StateMachine_Act

var animationLock : AnimationLock = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await self.owner.ready
	
	var parentPlayer = self.get_parent() as Player
	self.sm_locomotion = parentPlayer.locomotionState
#	self.process_callback = AnimationPlayer.ANIMATION_PROCESS_PHYSICS
	#self.sm_act = parentPlayer.actState
	pass # Replace with function body.


func request_oneShot(animation_name: String, lock: AnimationLock = null) -> void:
	if(self.animationLock != null) :
		if(lock == null):
			return
		elif	 (self.animationLock.prio > lock.prio):
			return
			
	self.play(animation_name)
	self.animationLock = lock		
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if( self.animationLock != null) :

		if(self.current_animation_position >= self.animationLock.lockTotal):
			self.animationLock = null
		

	if( self.animationLock != null ):
		return
	# Locomotion automation
	var curr_state_animation = sm_locomotion.state.main_animation
	if( not self.is_playing() or self.current_animation != curr_state_animation ) :
		self.play(curr_state_animation)


#func onAnimationFinished() -> void
