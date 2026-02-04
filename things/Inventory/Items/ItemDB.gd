class_name ItemDB_ extends Node

@export var extendBubbles: Array[Item]
@export var items_: Array[Item]

var items: Dictionary[StringName, Item]
#-ready -> build a dictionary of items, keyed by id
#get_item by id

func _ready() -> void:
	for item:Item in self.items_:
		self.items[item.id] = item
		
	for item:Item in self.extendBubbles:
		self.items[item.id] = item	
		
	
