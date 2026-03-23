class_name StateMachine extends Node

@export var initial_state :State = null
@onready var state: State
#@onready var state: State = (func get_initial_state() -> State: 
	#return initial_state if initial_state != null else get_child(0)).call()

var transition_locked: bool = false
var process_paused: bool = false
var physics_process_paused: bool = false 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await self.owner.ready	

	var body = self.get_parent() as CharacterBody2D
	var state_nodes: Array[Node] = find_children("*", "State")
	for state_node: State in state_nodes:
		state_node.finished.connect(self.transition_to_next_state)
		state_node.body = self.get_parent() as Actor
		
	
	##then we wait for our owner to be fully ready
	if(initial_state == null) :
		initial_state = state_nodes[0]
	
	if(initial_state != null):
		self.transition_to_next_state(initial_state.name)
		

			
func transition_to_next_state(target_state_path: String, transition_data: Dictionary = {}) -> void: 
	if(transition_locked):
		printerr("prevented transition to %s from %s" %[target_state_path, state.name])
		return 
		
	if ( not self.has_node( target_state_path) ):
		printerr(self.owner.name + "Undefined state at " + target_state_path)
		
		if(!self.initial_state):
			printerr("No initial state set. ")
			return
		
		target_state_path = self.initial_state.name
		
	var prev_state = self.state
	var next_state = self.get_node(target_state_path)	

	if(prev_state):
		if( !prev_state.can_enter( next_state )):
			return

	
		self.state.exit() 
	
	next_state.enter(prev_state, transition_data)	
	self.state = next_state
	
	transition_data["effects" ] = prev_state.exitEffects() if prev_state else []
	transition_data["effects"] += next_state.enterEffects() 
	self.state_transitioned.emit( prev_state, next_state, transition_data)

	
	
#func _unhandled_input(event: InputEvent) -> void:
	
	#state.handle_input( event )	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if(!process_paused):
		self.state.update(delta)

func _physics_process( delta: float) -> void:
	if(!physics_process_paused):
		self.state.physics_update(delta)
	
	
signal state_transitioned(prev_state: State, new_state: State, data: Dictionary)			
