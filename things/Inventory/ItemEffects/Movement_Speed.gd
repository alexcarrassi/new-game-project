class_name Movement_Speed_Multiplier extends ItemEffect
@export var multiplier: float = 2.0
@export var powerup_time: float = 5.0
func apply( ctx: ItemUseContext ) -> void:
	
	var player = ctx.actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"movement_speed_multiplier", self.multiplier)
	
	player.MAX_RUN_VELOCITY *= multiplier
	#Reset after powerup time
	Game.get_tree().create_timer(powerup_time).timeout.connect( func() -> void:
			playerEntry.stats.setStat(&"movement_speed_multiplier", 1)
			player.MAX_RUN_VELOCITY /= multiplier
	)

	
