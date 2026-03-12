class_name Increase_Movement_Speed extends ActorMod
@export var multiplier: float = 2.0

func _init() -> void:
	self.mod_id = &"Incr_Mov_Speed"
	timeActive  = 6.0

func activate(actor: Actor) -> void:
	var player = actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"movement_speed_multiplier", self.multiplier)
	player.MAX_RUN_VELOCITY *= multiplier


func deactivate(actor: Actor) -> void:
	
	var player = actor as Player
	
	var playerEntry = Game.getPlayerEntry(player.player_index)
	playerEntry.stats.setStat(&"movement_speed_multiplier", 0)
	player.MAX_RUN_VELOCITY /= multiplier
			
