@tool
class_name RebindRow extends HBoxContainer
@export var action_name: StringName
@export var label_name: String:
	set(value):
		label_name = value
		refresh_text()
		
	
@onready var action_label: Label = $ActionLabel
@onready var action_button: Button = $ActionButton

var waiting_for_input: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	refresh_text()
	action_button.pressed.connect( onActionButtonPressed)

func onActionButtonPressed() -> void:
	
	action_button.text = "..."
	waiting_for_input = true 
	
func _unhandled_input(event: InputEvent) -> void:	
	if(!waiting_for_input):
		return
	
		
	if( event is InputEventKey || event is InputEventMouseButton || event is InputEventJoypadButton):

		
		if ( not event.pressed ):
			return
	
	
		if( event is InputEventKey) :
			if ( event.keycode == KEY_ESCAPE || event.keycode == KEY_ENTER):
				waiting_for_input = false 
				get_viewport().set_input_as_handled()		
				return 
			
		waiting_for_input = false 
		rebind_action(event)
		refresh_text()
		action_button.release_focus()
		get_viewport().set_input_as_handled()		
			
	
	
func rebind_action(event: InputEvent) -> void:
	for old_event: InputEvent in InputMap.action_get_events( action_name ):
		InputMap.action_erase_event( action_name, old_event)
	InputMap.action_add_event(action_name, event)

func refresh_text() -> void:
	if(not is_node_ready()) :
		return
		
	var events: Array[InputEvent] = InputMap.action_get_events( action_name )

	if events.is_empty():
		action_button.text = "Unbound"
	else:
		action_button.text = events[0].as_text()
		
	action_label.text = label_name	
