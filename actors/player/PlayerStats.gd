class_name PlayerStats extends Resource

@export var stats: Dictionary[StringName, int] = {}

const STATKEY_BUBBLES_BLOWN: StringName = &"bubbles_blown"
const STATKEY_BUBBLES_POPPED: StringName = &"bubbles_popped"
const STATKEY_FIREBUBBLES_POPPED: StringName = &"firebubbles_popped"
const STATKEY_ITEMS_COLLECTED: StringName = &"items_collected"

signal statsUpdated()
#get_stat
func getStat(statKey: StringName) -> int:
	var stat =  self.stats.get(statKey, null)
	if(stat):
		return stat
	return 0


#set_stat
func setStat(statKey: StringName, value: int) -> void:
	if( self.stats.get(statKey, null) != null) :
		self.stats.set(statKey, value)
		
		self.statsUpdated.emit()
		
