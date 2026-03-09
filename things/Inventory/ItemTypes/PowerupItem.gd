#Powerup items are Inventory items with an activation lifecyle
class_name PowerupItem extends InventoryItem

@export var duration: float = -1
@export var cooldown: float = -1 

var isActive: bool = false 
var isOnCoolDown: bool = false 


@export var activationBehavior: ActivationBehavior
@export var deactivationBehavior: DeactivationBehavior 

func activate( ctx: ItemActionContext) -> void:
	
	#Are we cooled down?
	#Are we active? Does our effect stack allow another activation?
	
	#apply effects 
	#set a  cdeactivation timer, if duration > -1 . wire it up with the deactivation funcition
	
	pass
	
func deactivate( ctx: ItemActionContext) -> void:
	#can we deactivate?
	#undo the effects
	
	#set up a cooldown timer, if cooldown > -1. Set the isCooledDown flag to false at that timeout.
	
	pass	
