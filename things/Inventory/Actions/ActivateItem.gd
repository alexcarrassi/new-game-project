class_name ActivateItem extends ItemAction

func execute(ctx: ItemActionContext) -> void:
	
	if ctx.item is PowerupItem:	
		ctx.item.activate( ctx )
		
