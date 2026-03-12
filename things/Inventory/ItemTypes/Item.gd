class_name Item extends Resource

@export var id: StringName
@export var display_name: String
@export var ingameIcon: AtlasTexture 
@export var ItemEffects: Array[ItemEffect] = []


@export var itemPickup: PackedScene
@export var pickupActions: Array[ItemAction]
@export var useActions: Array[ItemAction]


func getPickup() -> ItemPickup :
	
	var pickupToReturn = null
	
	if(!self.itemPickup):
		pickupToReturn =  ItemDB.default_item_pickup.instantiate( ) as ItemPickup
	else:
		pickupToReturn = self.itemPickup.instantiate() as ItemPickup
			
	return pickupToReturn		


	
func pickup(ctx: ItemActionContext) -> void:
	for pickupAction: ItemAction in pickupActions:
		pickupAction.execute(ctx)

func use(ctx: ItemActionContext) -> void:
	for useAction: ItemAction in useActions:
		useAction.execute(ctx)
	pass
