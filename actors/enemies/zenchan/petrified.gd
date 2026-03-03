class_name Enemy_PETRIFIED extends State

var mod_RedSpeed: ActorMod

func enter(prev_state_path: String, data: Dictionary) :
	
	var actor = self.body as Enemy

	print("%s is petrified" % [actor.name])
	actor.loco_locked = true
	actor.act_locked = true
	self.main_animation = "PETRIFIED"
	
	
		
	
func exit() -> void:
	var actor = self.body
	actor.loco_locked = false 
	actor.act_locked = false 

	
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
