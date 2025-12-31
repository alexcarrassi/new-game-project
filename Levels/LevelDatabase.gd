class_name LevelDatabase_ extends Node

@export var levels: Dictionary[int, PackedScene]

@export var levelDefinitions: Dictionary[String, LevelDefinition]

func getLevelDefinition( id: String) -> LevelDefinition:
	return self.levelDefinitions.get(id, null)
	
func getNextLevelDefinitionByExit( current_id: String, exit_id: String) -> LevelDefinition:
	if(self.levelDefinitions.has(current_id)) :
		var next_id = self.levelDefinitions[current_id].default_next
		
		return self.getLevelDefinition(next_id)
	
	return null	
	
