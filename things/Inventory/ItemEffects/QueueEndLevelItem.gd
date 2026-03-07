class_name QueueEndLevelItem extends ItemEffect

@export var item: Item

func apply( ctx: ItemUseContext ) -> void:
	print("pushing item to endlevelitemspawner")
	
	Game.world.endLevelItemSpawn.items.push_front( item )
	
	pass

	
	
