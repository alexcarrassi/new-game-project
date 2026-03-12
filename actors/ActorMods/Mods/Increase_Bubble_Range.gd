class_name Increase_Bubble_Range extends ActorMod
@export var range_extension: float = 60.0

func _init() -> void:
	self.mod_id = &"Incr_Bubble_Range"
	timeActive  = 6.0

func activate(actor: Actor) -> void:
	var player = actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"bubble_range", range_extension)


func deactivate(actor: Actor) -> void:
	
	var player = actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"bubble_range", 0)
