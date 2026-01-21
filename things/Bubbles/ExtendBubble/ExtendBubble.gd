class_name ExtendBubble extends Bubble

var item: Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	self.setFloating()
	pass # Replace with function body.

func _enter_tree() -> void:
	if(self.item != null):
		print(self.item.id)
	else:
		print("item is null")

func playerPop(player: Player) -> void:	
	super.playerPop(player)
	player.Inventory.addItem( self.item.id )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
