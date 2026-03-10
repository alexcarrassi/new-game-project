# Powerup items are Items that support inventory functionality, an activation lifecyle
class_name PowerupItem extends InventoryItem

@export var duration: float = -1
@export var cooldown: float = -1 

var isActive: bool = false 
var isOnCoolDown: bool = false 


@export var activationActions: Array[ItemAction]
@export var deactivationActions: Array[ItemAction]

func activate( ctx: ItemActionContext) -> void:
	
	
	# Can't activate if on cooldown
	if( isOnCoolDown ) :
		return
			
	#Are we active? Does our effect stack allow another activation?
	
	# Apply the item's effects 
	for effect in ItemEffects:
		effect.apply(ctx)
	
	# Set a deactivation timer if the powerup has a set duration
	if(duration > 0):
		ctx.actor.get_tree().create_timer(duration).timeout.connect( func() -> void:
			deactivate(ctx)
		)	
	pass
	
func deactivate( ctx: ItemActionContext) -> void:
	#If this is an Active item, we need to undo all the effects
	if(isActive) :
		for effect in ItemEffects: 
			effect.clear( ctx )
	
	# Setsup a cooldown timer, if cooldown > -1. 
	# On timeout, unset the isOnCooldown flag
	if(cooldown > 0) :
		ctx.actor.get_tree().create_timer( cooldown).timeout.connect( func() -> void:
			isOnCoolDown = false
		)
	pass	
