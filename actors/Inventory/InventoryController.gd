class_name InventoryController extends Resource 

var actor: Actor
var items: Dictionary [StringName, ItemEntry] = {}

signal inventoryUpdated() 

func _init(actor: Actor) -> void:
	self.actor = actor
	
func addItem(item_id: StringName, itemType: StringName = &"") -> void:
	
	var itemToAdd : Item = ItemDB.getItem(item_id, itemType)
	
	if( itemToAdd ):
		var entry = self.items.get_or_add(item_id, null)
		if(entry):
			#check if we can increase the stack
			entry.stack += 1 if entry.item.stackable else 0
			pass 
		else: 
			#create new entry
			entry = ItemEntry.new(itemToAdd, 1) 		
			self.items[item_id] = entry
			
	#emit a signal	
	self.inventoryUpdated.emit()	
	if(self.actor is Player):
		var playerEntry = Game.getPlayerEntry(self.actor.player_index)
		var stat = playerEntry.stats.getStat(PlayerStats.STATKEY_ITEMS_COLLECTED)
		playerEntry.stats.setStat(PlayerStats.STATKEY_ITEMS_COLLECTED, stat + 1)	
	
	
	pass
	
func getItem(item_id: StringName) -> ItemEntry:
	return self.items.get(item_id, null)
	
func removeItem(item_id: StringName) -> void: 
	
	var entryToRemove: ItemEntry = self.items.get(item_id, null)
	if(entryToRemove):
		entryToRemove.stack -= 1
		
		if(entryToRemove.stack < 1 ):
			self.items.erase(item_id)	
			
	#emit a signal
	self.inventoryUpdated.emit()	

			
