class_name StateMachine extends Node

@export var initial_state :State = null

@onready var state: State = (func get_initial_state() -> State: 
	return initial_state if initial_state != null else get_child(0)).call()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var body = self.get_parent() as CharacterBody2D
	for state_node: State in self.find_children("*", "State"):
		state_node.finished.connect(self._transition_to_next_state)
		state_node.body = self.get_parent() as CharacterBody2D
		
	
	#then we wait for our owner to be fully ready
	await self.owner.ready	
	
	self.state_transitioned.emit(null, self.state, {})
	self.state.enter("", {})


	
func _transition_to_next_state(target_state_path: String, transition_data: Dictionary = {}) -> void: 
	if ( not self.has_node( target_state_path) ):
		printerr(self.owner.name + "Undefined state at " + target_state_path)
		return
		
	var prev_state = self.state
	var next_state = self.get_node(target_state_path)
	
	self.state.exit() 
	self.state = next_state
	self.state.enter(prev_state.name, transition_data)	
	
	transition_data["effects"] = prev_state.exitEffects() + next_state.enterEffects() 
	self.state_transitioned.emit( prev_state, next_state, transition_data)

	
	
func _unhandled_input(event: InputEvent) -> void:
	self.state.handle_input( event )	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	self.state.update(delta)

func _physics_process( delta: float) -> void:
	self.state.physics_update(delta)
	
	
signal state_transitioned(prev_state: State, new_state: State, data: Dictionary)			
