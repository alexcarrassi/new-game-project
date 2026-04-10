class_name SaveGame extends Node
# Manages (De)serialization

const SAVEGAME_PATH = "user://savegame.json"


static func serialize() -> Dictionary:
	var dict = {"playerentries" = {}, "gamestate" = {}}

	dict["gamestate"] = {
		levelid = Game.world.level.definition.id,
		game_mode = Game.world.game_mode,
		difficulty = Game.difficulty,
	}
	for player_index: int in Game.playerEntries.keys():
		var playerEntry = Game.playerEntries.get(player_index)
		dict["playerentries"][player_index] = playerEntry.serialize()

	return dict
	
static func deserialize(dict: Dictionary) -> void:
	
	
	print(dict)
	return	
	
	
static func saveFile() -> bool:
	
	print(OS.get_user_data_dir())
	var dict = SaveGame.serialize()
	
	var file: FileAccess = FileAccess.open(SAVEGAME_PATH, FileAccess.WRITE)
	if(file == null): 
		push_error("Failed to open (a new) save file")
		return false 
	
	file.store_string(JSON.stringify( dict ))	
	file.close() 
	return true
		
static func loadFile(  ) -> bool:
	if not FileAccess.file_exists( SAVEGAME_PATH):
		return false
	
	var file: FileAccess = FileAccess.open( SAVEGAME_PATH, FileAccess.READ)
	if file == null: 
		return false 
		
	var content: String = file.get_as_text()	
	file.close() 
	
	var json = JSON.new() 
	if(json.parse(content) != OK):
		return false
		
	
	SaveGame.deserialize( json.data )	
	
	return true 
