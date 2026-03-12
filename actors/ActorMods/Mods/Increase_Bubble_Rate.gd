class_name Increase_Bubble_Rate extends ActorMod
@export var rate_multiplier: float = 3

func _init() -> void:
	self.mod_id = &"Incr_Bubble_Rate"
	timeActive  = 6.0

func activate(actor: Actor) -> void:
	var player = actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"bubble_rate", rate_multiplier)


func deactivate(actor: Actor) -> void:
	
	var player = actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"bubble_rate", 1)
