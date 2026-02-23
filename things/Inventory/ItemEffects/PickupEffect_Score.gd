class_name PickupEffect_Score extends ItemEffect

@export var score: int = 100
@export var texture: Texture2D



func apply( ctx: ItemUseContext) -> void:
	
	var actor  = ctx.actor
	#var newPopup = popup.instantiate() as Sprite2D 
	if( actor is Player) :

		actor.score += self.score
		actor.scoreUpdated.emit(  )
		
		var pointResource = ItemDB.pointsDB.getPointRect(actor.player_index, self.score)
		ctx.itemPickup.spritePickup.texture = pointResource
		ctx.itemPickup.spritePickup.region_rect = Rect2i(0, 0, pointResource.region.size.x, pointResource.region.size.y)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
		


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
