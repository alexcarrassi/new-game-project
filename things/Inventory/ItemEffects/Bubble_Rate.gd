class_name Bubble_Rate extends Powerup
@export var rate_multiplier: float = 3

func apply( ctx: ItemActionContext ) -> void:
	super.apply(ctx)

func start(ctx: ItemActionContext) -> void:	
	var player = ctx.actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"bubble_rate", rate_multiplier)
	
func end(ctx: ItemActionContext) -> void:
	var player = ctx.actor as Player
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"bubble_rate", 1)
	
	
