class_name Bubble_Rate extends ItemEffect
@export var rate_multiplier: float = 3
@export var powerup_time: float = 5.0
func apply( ctx: ItemUseContext ) -> void:
	
	var player = ctx.actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"bubble_rate", rate_multiplier)
	
	#Reset after powerup time
	Game.get_tree().create_timer(powerup_time).timeout.connect( func() -> void:
			playerEntry.stats.setStat(&"bubble_rate", 1)

	)

	
