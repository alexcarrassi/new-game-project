class_name ItemSpawn extends Node2D

@onready var timer: Timer = $Timer

@export var item: Item
@export var spawnTime: float = 6.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.timer.wait_time = self.spawnTime
	self.timer.timeout.connect( self.spawnItem)
	pass # Replace with function body.

func spawnItem() -> ItemPickup:
	if( self.item ) :

		var itemPickup = item.itemPickup.instantiate() as ItemPickup
		itemPickup.setData( item )

		get_tree().root.add_child( itemPickup )
		itemPickup.position = self.position
		
		return itemPickup
	return null	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
