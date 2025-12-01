#Game (Autoload)
class_name auGame extends Node


var world: GameWorld 
var players : Dictionary[int, Player]
var currentLevel: int = 0

var levels: Dictionary[int, PackedScene]

var difficulty = 1

func register_player(index: int, player: Player) -> Dictionary[int, Player]:
	self.players[index] = player
	return self.players	
	

func deregister_player(index: int) -> Dictionary[int, Player]:
	self.players.erase(index)  
	return self.players

func getLevelById( index: int) -> PackedScene:
	return LevelDatabase.levels[index]

func register_currentLevel( level_index: int) -> int:
	self.currentLevel = level_index
	return self.currentLevel
	
func getNextLevel_id() -> int:
	var next_id = self.currentLevel + 1
	if(LevelDatabase.levels.has( next_id ) ):
		return next_id
	else :
		return -1	
		
	
func register_gameWorld(node:GameWorld) -> GameWorld:
	self.world = node 
	return self.world	
