class_name AnimationController extends AnimationPlayer

var current_state_animation: String
var current_library = "NORMAL"
enum StatePriority{ STATUS = 20, ACT = 10, LOCOMOTION = 0 }
var animationLock : AnimationLock = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await self.owner.ready
	
	#var parentPlayer = self.get_parent() as CharacterBody2D
#	self.process_callback = AnimationPlayer.ANIMATION_PROCESS_PHYSICS
	#self.sm_act = parentPlayer.actState
	pass # Replace with function body.

func set_current_library(name: String) -> void:
	if (self.has_animation_library(name)) :
		self.set_current_library( name )
	else:
		printerr("Tried setting animation library %s, but actor does not have it" %[name])	
	pass

#Can loop n amount of times.
func request_oneShot(animation_name: String, lock: AnimationLock = null) -> void:
	if(self.animationLock != null) :
		if(lock == null):
			return
		elif	 (self.animationLock.prio > lock.prio):
			return
			
	self.play(animation_name)
	self.animationLock = lock		

func onStateTransition(prev_state: State, new_state: State, transition_data: Dictionary) -> void:
	
	if(transition_data.has("effects") ):
		for  effect:Dictionary  in transition_data["effects"]:
			if (effect.has("oneshot")):
	
				var animation = self.get_animation( effect["oneshot"]["animation"] )
				var loops = effect.get("loops", 1)
				var animationLock = AnimationLock.new( effect["oneshot"]["prio"], animation.length, loops)
				
				self.request_oneShot( effect["oneshot"]["animation"] , animationLock)
			
	if(new_state.main_animation != "") :
		self.current_state_animation = new_state.main_animation
		
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if( self.animationLock != null) :

		
		self.animationLock.current -= delta
		if( self.animationLock.current <= 0) :
			self.animationLock.current = self.animationLock.lockTotal
			self.animationLock.loops -= 1
			if(self.animationLock.loops < 1) :
					self.animationLock.lockReleased.emit()
					self.animationLock = null
					
					
		#if(self.current_animation_position >= self.animationLock.lockTotal):
			#self.animationLock.loops -= 1
			#
			#if(self.animationLock.loops < 1) :
				#
				#self.animationLock = null
		#

	if( self.animationLock != null ):
		return
		
	# Locomotion automation
	if( not self.is_playing() or self.current_animation != self.current_state_animation ) :
		#if( self.current_state_animation != "") :
			
			self.play(self.current_state_animation)


#func onAnimationFinished() -> void
