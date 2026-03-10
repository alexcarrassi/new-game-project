class_name ConsumeItem extends ItemAction

func execute(ctx: ItemActionContext) -> void:
	
	if ctx.actor is Player:	
		var player = ctx.actor as Player 
		var playerEntry = Game.getPlayerEntry( player.player_index)
		var itemEntry  = playerEntry.inventory.consumeItem( ctx.item.id)
		
