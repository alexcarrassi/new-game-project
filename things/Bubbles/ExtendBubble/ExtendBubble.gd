class_name ExtendBubble extends Bubble

var item: Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	self.setFloating()
	#self.determineExtendType(Game.playerEntires.get(0).player)

	pass # Replace with function body.

func _enter_tree() -> void:
	
	#Assume player 1 for now
	if(self.item != null):
		print(self.item.id)
	else:
		print("item is null")

func playerPop(player: Player) -> void:	
	super.playerPop(player)
	var inventory = Game.getPlayerEntry(player.player_index).inventory
	inventory.addItem( self.item.id )
func setType(type: StringName) -> void:
	
	var item = ItemDB.items.get(type)
	if(item):
		self.item = item
		var inventoryIcon = self.item.inventoryIcon as AtlasTexture	
		self.sprite.region_rect = inventoryIcon.region
		self.sprite.visible = true

	
#Exactly which extend bubble should we spawn?
func determineExtendType(player: Player) -> void:
	var playerInventory = player.Inventory.items 
	
	if(playerInventory.get("extend_E1") == null):
		self.item = ItemDB.items.get("extend_E1")
	elif (playerInventory.get("extend_X") == null):
		self.item = ItemDB.items.get("extend_X")
	elif (playerInventory.get("extend_T") == null):
		self.item = ItemDB.items.get("extend_T")
	elif (playerInventory.get("extend_E2") == null):
		self.item = ItemDB.items.get("extend_E2")
	elif (playerInventory.get("extend_N") == null):
		self.item = ItemDB.items.get("extend_N")
	elif (playerInventory.get("extend_D") == null):
		self.item = ItemDB.items.get("extend_D")		

	if(self.item == null) :
		#Player already has all Extend bubbles. Terminate
		self.queue_free()
		return
			
	var inventoryIcon = self.item.inventoryIcon as AtlasTexture	
	self.sprite.region_rect = inventoryIcon.region
	self.sprite.visible = true
	pass
	
	
func _physics_process(delta: float) -> void:
	if(!self.destination) :
		self.destination = Game.world.level.bubbleDestination
	match self.state: 
		_:
			self.target_velocity = self.float(delta)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
