#Uses an item immediately on pickup
class_name UseOnPickup extends PickupBehavior

func pickup(ctx: ItemActionContext) -> void:
	ctx.item.use( ctx )
	pass
