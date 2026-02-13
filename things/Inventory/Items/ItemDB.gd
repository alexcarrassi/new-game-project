class_name ItemDB_ extends Node

@export var extendBubbles_: Array[Item]
@export var items_: Array[Item]
@export var powerups_: Array[Item]

var items: Dictionary[StringName, Item]
var extendBubbles: Dictionary[StringName, Item]
#-ready -> build a dictionary of items, keyed by id
#get_item by id

func _ready() -> void:
	for item:Item in self.items_:
		self.items[item.id] = item
		
	for item:Item in self.extendBubbles_:
		self.extendBubbles[item.id] = item	
		
func getItem(name: StringName, itemType: StringName = &"item") -> Item:
	
	var source = self.items
	match( itemType ):
		&"ExtendBubble":
			source = self.extendBubbles
		&"Item", _:
			source = self.items	
	
	var item = source.get(name, null)		
	if(item == null) :
		# If Not found, return the first available item
		var keys = self.items.keys()
		if(keys.size() > 0):
			item =  self.items[keys[0]]
			
	return item		
	
func getExtendbubble(name: StringName) -> Item:
	var item = self.extendBubbles.get(name, null)		
	if(item == null) :
		# If Not found, return the first available item
		var keys = self.extendBubbles.keys()
		if(keys.size() > 0):
			item =  self.extendBubbles[keys[0]]
			
	return item		
