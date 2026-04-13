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
			entry = ItemEntry.new(itemToAdd, 1, itemType) 		
			self.items[item_id] = entry
			
	#emit a signal	
	self.inventoryUpdated.emit()	
	if(self.actor is Player):
		self.actor.statEvent.emit(PlayerStats.STATKEY_ITEMS_COLLECTED, 1 )
	
	pass
	
func getItem(item_id: StringName) -> ItemEntry:
	return self.items.get(item_id, null)
	
func consumeItem(item_id: StringName) -> void: 
	
	var entryToRemove: ItemEntry = self.items.get(item_id, null)
	if(entryToRemove):
		entryToRemove.stack -= 1
		
		if(entryToRemove.stack < 1 ):
			self.items.erase(item_id)	
			
	#emit a signal
	self.inventoryUpdated.emit()	

			
			
func deserialize(data: Dictionary) -> void:
	
	print("deserialize inventory")
	
	if(data.has("entries")):
		for itemData: Dictionary in data["entries"]:
			addItem(itemData["id"], itemData["type"])
			getItem(itemData["id"]).stack = itemData["stack"]
			
			
	print(data)
	
	inventoryUpdated.emit()	

	
	return

func serialize() -> Dictionary:
	var data = {"entries" = []}
	
	for itemID: StringName in items.keys(): 
		var itemEntry = getItem(itemID)
		data["entries"].append({ 
			"id" : itemID,
			"stack" : itemEntry.stack,
			"type": itemEntry.type
		})
	
	return data 
				
