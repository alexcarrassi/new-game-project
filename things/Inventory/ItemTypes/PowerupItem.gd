# Powerup items are Items that support inventory functionality, an activation lifecyle
class_name PowerupItem extends InventoryItem

@export var cooldown: float = -1 

var isActive: bool = false 
var isOnCoolDown: bool = false 


@export var activationActions: Array[ItemAction]
@export var deactivationActions: Array[ItemAction]

func activate( ctx: ItemActionContext) -> void:
	
	for action: ItemAction in activationActions:
		action.execute(ctx)
	
	# Can't activate if on cooldown
	if( isOnCoolDown ) :
		return
			
	# Are we active? Does our effect stack allow another activation?
	
	# Apply the item's effects 
	for effect in ItemEffects:
		effect.apply(ctx)
	
	# Set a cooldown timer if the powerup has a set cooldown
	if(cooldown > 0):
		isOnCoolDown = true
		ctx.actor.get_tree().create_timer(cooldown).timeout.connect( func() -> void:
			isOnCoolDown = false
		)	
	pass
	
	isActive = true
