class_name ItemEffect_SkipLevels extends ItemEffect

@export var levelCount_min: int = 1
@export var levelCount_max: int = 1


func apply( ctx: ItemUseContext) -> void:
	
	var rng = RandomNumberGenerator.new()
	var skipCount = rng.randi_range(self.levelCount_min, self.levelCount_max)
	
	if(!Game.world.is_transitioning_Levels):
		Game.world.levelTransition({"cinematic" : true, "loopCount": skipCount})
	
