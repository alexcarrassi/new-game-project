class_name EmitExtendBubble extends ItemEffect


func apply( ctx: ItemActionContext ) -> void:
	
	
	var bubbleSpawner = Game.world.extendBubbleSpawner_left
	var rng = randi_range(0,1)
	if(rng > 0):
		bubbleSpawner = Game.world.extendBubbleSpawner_right
		
		
	Game.world.extendBubbleSpawner_left.spawnBubble()
	bubbleSpawner.bubbleQueue.push_front(    ItemDB.getRandomExtendBubbleKey() )
	bubbleSpawner.spawnBubble()
	
	pass

	
	
