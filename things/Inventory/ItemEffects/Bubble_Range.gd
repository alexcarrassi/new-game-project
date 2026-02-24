class_name Bubble_Range extends ItemEffect
@export var range_extension: float = 60.0
@export var powerup_time: float = 5.0
func apply( ctx: ItemUseContext ) -> void:
	
	var player = ctx.actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"bubble_range", self.range_extension)
	
	#Reset after powerup time
	Game.get_tree().create_timer(powerup_time).timeout.connect( func() -> void:
			playerEntry.stats.setStat(&"bubble_range", 0)

	)

	
