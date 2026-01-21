class_name ItemDB_ extends Node

@export var items_: Array[Item]

var items: Dictionary[StringName, Item]
#-ready -> build a dictionary of items, keyed by id
#get_item by id

func _ready() -> void:
	for item:Item in self.items_:
		self.items[item.id] = item
		
		
	
