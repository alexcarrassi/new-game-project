class_name Item extends Resource

@export var id: StringName
@export var display_name: String
@export var ingameIcon: AtlasTexture 
@export var inventoryIcon: Texture2D
@export var ItemEffects: Array[ItemEffect] = []
@export var stackable: bool = false
@export var maxStack: int = 1

@export var itemPickup: PackedScene
@export var pickupBehavior: PickupBehavior
@export var useBehavior: UseBehavior


func getPickup() -> ItemPickup :
	
	var pickupToReturn = null
	
	if(!self.itemPickup):
		pickupToReturn =  ItemDB.default_item_pickup.instantiate( ) as ItemPickup
	else:
		pickupToReturn = self.itemPickup.instantiate() as ItemPickup
			
	return pickupToReturn		


func getPickupBehavior() -> PickupBehavior:
	return pickupBehavior if pickupBehavior != null else UseOnPickup.new()
	
	
func getUseBehavior() -> UseBehavior:
	return useBehavior if useBehavior != null else 	ConsumeOnUse.new()
	
func pickup(ctx: ItemActionContext) -> void:
	getPickupBehavior().pickup(ctx)

func use(ctx: ItemActionContext) -> void:
	getUseBehavior().use(ctx)
	pass
