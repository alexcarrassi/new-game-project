class_name PlayerStats extends Resource

@export var values: Dictionary[StringName, int] = {}
@export var rewarded: Dictionary[StringName, int] = {}

const STATKEY_BUBBLES_BLOWN: StringName = &"bubbles_blown"
const STATKEY_BUBBLES_POPPED: StringName = &"bubbles_popped"
const STATKEY_WATERBUBBLES_POPPED: StringName = &"waterbubbles_popped"
const STATKEY_FIREBUBBLES_POPPED: StringName = &"firebubbles_popped"
const STATKEY_THUNDERBUBBLES_POPPED: StringName = &"thunderbubbles_popped"
const STATKEY_ITEMS_COLLECTED: StringName = &"items_collected"
const STATKEY_BUBBLES_HOPPED: StringName = &"bubbles_hopped"
const STATKEY_BUBBLE_RATE_MULT: StringName = &"bubble_rate"
const STATKEY_BOTTELEPORT: StringName	= &"bot_to_top_teleports"

signal statsUpdated()

func createStatsFromSchema(statSchema: PlayerStats_Schema):
	for statDef: PlayerStatDef in statSchema.stats:
		self.values[statDef.key] = statDef.value
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
func incrementStat(statKey: StringName, incr_by: int) -> void:
	var statval = getStat( statKey)
	setStat( statKey, statval + incr_by) 		

func onStatEvent(statKey: StringName, value: int) -> void:

	match(statKey):
		_:
			incrementStat(statKey, value)
	
	print("Updating %s" %[statKey])


func serialize() -> Dictionary: 
	var data = {
		"values" = {},
		"rewared" = {}
		} 
	
	for statKey: StringName in values.keys():
		data["values"][statKey] = values.get(statKey)
	
	for statKey: StringName in rewarded.keys():
		data["rewared"][statKey] = rewarded.get(statKey)
	
	
	
	return data 
