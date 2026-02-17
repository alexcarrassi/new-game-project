class_name PlayerStats extends Resource

@export var values: Dictionary[StringName, int] = {}
@export var rewarded: Dictionary[StringName, int] = {}

const STATKEY_BUBBLES_BLOWN: StringName = &"bubbles_blown"
const STATKEY_BUBBLES_POPPED: StringName = &"bubbles_popped"
const STATKEY_WATERBUBBLES_POPPED: StringName = &"waterbubbles_popped"
const STATKEY_FIREBUBBLES_POPPED: StringName = &"firebubbles_popped"
const STATKEY_THUNDERBUBBLES_POPPED: StringName = &"thunderbubbles_popped"
const STATKEY_ITEMS_COLLECTED: StringName = &"items_collected"

signal statsUpdated()

func createStatsFromSchema(statSchema: PlayerStats_Schema):
	for statDef: PlayerStatDef in statSchema.stats:
		self.values[statDef.key] = 0
		self.rewarded[statDef.key] = 0
#get_stat
func getStat(statKey: StringName) -> int:
	var stat =  self.values.get(statKey, null)
	if(stat):
		return stat
	return 0

func getStatEntry(statKey: StringName) -> PlayerStatDef:
	return self.stats[statKey]
#set_stat
func setStat(statKey: StringName, value: int) -> void:
	var stat = self.values.get(statKey, null)
	if( stat != null) :
		self.values[statKey] = value
		
		self.statsUpdated.emit()
		
