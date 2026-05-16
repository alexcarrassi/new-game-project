class_name HighScoreManager extends Node

const PATH_NAME: String = "user://highscores.cfg"
const max_slots = 10
var high_scores: Array[HighscoreEntry]

var entryQueue: Array[HighscoreEntry] = []


# Queue a new entry. Only add if it is higher than any other entry of the same playername
func queue_entry(new_entry: HighscoreEntry) -> void:
	for entry: HighscoreEntry in entryQueue:
		if( entry.playername == new_entry.playername):
			if new_entry.score < entry.score:
				return
	
	entryQueue.append( new_entry)			

func add_queued_entries() -> void:
	for entry: HighscoreEntry in entryQueue:
		add_entry(entry)
	
	entryQueue = []	

func add_entry(new_entry: HighscoreEntry) -> void:

	var index: int = 0
		
	for entry: HighscoreEntry in high_scores:
		if( new_entry.score > entry.score):
			break
			
		index += 1	
	
	if( index < max_slots):
		high_scores.insert(index, new_entry)
		
					
	
func load_highscores() -> Array[HighscoreEntry]:
	
	var t_high_scores: Array[HighscoreEntry] =  []
	var file: ConfigFile = ConfigFile.new()
	var err = file.load(PATH_NAME)
	
	if(err != OK):
		printerr(err)
	
	
	for section_key in file.get_sections():
		var entry: HighscoreEntry = HighscoreEntry.new() 
		entry.is_saved = true
		entry.playername = file.get_value(section_key, "playername")
		entry.score = file.get_value(section_key, "score")		
		t_high_scores.append(entry)
		
	high_scores = t_high_scores	
	
	add_queued_entries()
	
	save_highscores()

	return high_scores
pass



func save_highscores() -> void:
	var scoreFile = ConfigFile.new() 
	high_scores.resize(max_slots)	

	for i in range(high_scores.size()):
		var entry: HighscoreEntry = high_scores[i]
		scoreFile.set_value(str(i), "score", entry.score)
		scoreFile.set_value(str(i), "playername", entry.playername)

		pass
		
		
	scoreFile.save(PATH_NAME)	
