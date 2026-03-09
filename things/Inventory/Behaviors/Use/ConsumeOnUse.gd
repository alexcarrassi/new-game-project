# applies all of the Item's effects and then consumes itself from the Actor's Inventory
class_name ConsumeOnUse extends UseBehavior

func use(ctx: ItemActionContext) -> void:
	
	for effect: ItemEffect in ctx.item.ItemEffects:
		effect.apply( ctx )
		
	if ctx.actor is Player:	
		var player = ctx.actor as Player 
		var playerEntry = Game.getPlayerEntry( player.player_index)
		var itemEntry  = playerEntry.inventory.consumeItem( ctx.item.id)
		
