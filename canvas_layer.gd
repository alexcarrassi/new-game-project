#Input debug layer 
#Shows the input as a simple text in a CanvasLayer
#Updates every n frames

extends CanvasLayer
@onready var label: Label = $Control/MarginContainer/Label

var accum: float = 0.0
var update_interval: float = 0.01
var player: Player

func setPlayer() -> void:
	var player =   get_tree().get_first_node_in_group("player")
	if(player):
		self.player = player

			
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("toggle_debug")):
		self.visible = !self.visible
	
	if( not self.visible): return
	
	accum += delta
	
	if( accum < update_interval) : return
	
	accum = 0
	
	if( not self.player) :
		self.setPlayer()
				
	self.label.text = self.player.exposeInputSnapshot()
	
		
		
