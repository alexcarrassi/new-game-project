class_name ApplyAllItemEffects extends ItemAction

func execute(ctx: ItemActionContext) -> void:
	for effect: ItemEffect in ctx.item.ItemEffects:
		effect.apply( ctx )
