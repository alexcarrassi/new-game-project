class_name StateMachine extends Node

@export var initial_state :State = null

@onready var state: State = (func get_initial_state() -> State: 
	return initial_state if initial_state != null else get_child(0)).call()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var player = self.get_parent() as Player
	var animationController = player.get_node("AnimationPlayer") as AnimationController
	
	
	for state_node: State in self.find_children("*", "State"):
		state_node.finished.connect(self._transition_to_next_state)
		state_node.player = self.get_parent() as Player
		state_node.animationController = animationController
		
	
	#then we wait for our owner to be fully ready
	await self.owner.ready	
	self.state.enter("", {})


	
func _transition_to_next_state(target_state_path: String, transition_data: Dictionary = {}) -> void: 
	if ( not self.has_node( target_state_path) ):
		printerr(self.owner.name + "Undefined state at " + target_state_path)
		return
		
	var prev_state_path = self.state.name
	self.state.exit() 
	self.state = self.get_node( target_state_path )
	self.state.enter(prev_state_path, transition_data)	

	
	
func _unhandled_input(event: InputEvent) -> void:
	self.state.handle_input( event )	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.state.update(delta)

func _physics_process( delta: float) -> void:
	self.state.physics_update(delta)
			
