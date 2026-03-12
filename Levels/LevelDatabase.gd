class_name LevelDatabase_ extends Node

@export var levelDefinitions: Dictionary[String, LevelDefinition]

@export var levels: Array[LevelDefinition]

func getLevelDefinition( id: String) -> LevelDefinition:
	var index =  levels.find_custom( func(level: LevelDefinition) -> bool: return level.id == id)
	if(index == -1):
		index = 0
		
	return levels[index]
	
	
func getNextLevelDefinitionByExit( current_id: int, exit_id: String) -> LevelDefinition:
	if(levels[current_id]) :
		var next_id = levels[current_id].default_next
		
		return self.getLevelDefinition(next_id)
	
	return null	
	
