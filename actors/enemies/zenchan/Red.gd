class_name Enemy_RED extends State

var mod_RedSpeed: ActorMod

func enter(prev_state_path: String, data: Dictionary) :
	
	var actor = self.body 
	self.mod_RedSpeed = RedSpeed.new()
	actor.modController.addMod( self.mod_RedSpeed )
	
	pass
	
	
func exit() -> void:
	var actor = self.body
	actor.modController.removeMod(self.mod_RedSpeed, true)
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func physics_update(delta: float) -> void:
	print("RED")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
