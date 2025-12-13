class_name ActorMod extends Resource

var stackable: bool = false
var timeActive: float = -1 #-1 indicates an indefinite mod
var isPassive: bool = true
var mod_id: String


func activate(actor: Actor) -> void:
	pass

func deactivate(actor: Actor) -> void:
	pass
	
func tick_physics(delta: float, actor: Actor) -> void: 		
	pass
	
func tick_process(delta: float, actor: Actor) -> void:
	pass	
	
	
