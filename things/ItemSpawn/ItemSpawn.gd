class_name ItemSpawn extends Node2D

@onready var timer: Timer = $Timer

@export var items: Array[Item]
@export var spawnTime: float = 6.0
@export var autoStart: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if(autoStart):
		self.timer.wait_time = self.spawnTime
		self.timer.timeout.connect( self.spawnItem)
	pass # Replace with function body.

func spawnItem() -> ItemPickup:
	if( self.items.size() > 0 ) :
		var item = self.items.pop_front()
		var itemPickup: ItemPickup
		if(item.itemPickup != null):
			itemPickup = item.itemPickup.instantiate() as ItemPickup
		else:
			itemPickup = ItemDB.default_item_pickup.instantiate( ) as ItemPickup
		
		itemPickup.item = item
		itemPickup.position = self.position

		Game.world.level.add_child(itemPickup)
		
		return itemPickup
	return null	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
