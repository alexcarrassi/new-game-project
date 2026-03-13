class_name PlayerBubblesToItems extends ItemEffect

@export var item: Item

func apply( ctx: ItemActionContext ) -> void:


	if(item) :
		
		Game.world.level.level_cleared.connect( func() -> void: 
			
			var bubbles = Game.world.get_tree().get_nodes_in_group("PlayerBubble")
			for bubble: PlayerBubble in bubbles:
				var itemPickup: ItemPickup
				
				if(item.itemPickup != null):
					itemPickup = item.itemPickup.instantiate() as ItemPickup
				else:
					itemPickup = ItemDB.default_item_pickup.instantiate( ) as ItemPickup
			
				itemPickup.position = bubble.position
				itemPickup.item = item
				Game.world.level.add_child(itemPickup)
				bubble.queue_free()
				print(bubbles)
		)

	
