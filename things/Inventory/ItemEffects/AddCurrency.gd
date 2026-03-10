class_name AddCurrency extends ItemEffect

@export var score: int = 100



func apply( ctx: ItemActionContext) -> void:
	
	var actor  = ctx.actor
	#var newPopup = popup.instantiate() as Sprite2D 
	if( actor is Player) :

		var currencyItem = ctx.item as CurrencyItem
		actor.updateCurrency( currencyItem.value, currencyItem.currencyType)
		
		var pointResource = ItemDB.pointsDB.getPointRect(actor.player_index, currencyItem.value)
		ctx.itemPickup.spritePickup.texture = pointResource
		ctx.itemPickup.spritePickup.region_rect = Rect2i(0, 0, pointResource.region.size.x, pointResource.region.size.y)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
		


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
