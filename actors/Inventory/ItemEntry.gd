class_name ItemEntry extends Resource

var item: Item 
var stack: int = 0

func _init(item: Item, stack: int) -> void:
	self.item = item 
	self.stack = stack
