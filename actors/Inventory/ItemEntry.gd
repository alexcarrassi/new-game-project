class_name ItemEntry extends Resource

var item: Item 
var stack: int = 0
var type: StringName

func _init(item: Item, stack: int, type: StringName) -> void:
	self.item = item 
	self.stack = stack
	self.type = type
