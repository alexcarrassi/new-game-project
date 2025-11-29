#Game (Autoload)
class_name auGame extends Node


var world: GameWorld 
var players : Dictionary[int, Player]
var currentLevel: Level

var difficulty = 1

func register_player(index: int, player: Player) -> Dictionary[int, Player]:
	self.players[index] = player
	return self.players	
	

func deregister_player(index: int) -> Dictionary[int, Player]:
	self.players.erase(index)  
	return self.players


func register_currentLevel( level: Level) -> Level:
	self.currentLevel = level
	return self.currentLevel
	
	
func register_gameWorld(node:GameWorld) -> GameWorld:
	self.world = node 
	return self.world	
