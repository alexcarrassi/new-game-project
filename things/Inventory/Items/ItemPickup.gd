class_name ItemPickup extends Area2D

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

@export var popupShowTime: float = 0.50 
@export var popupYSpeed: float = 50
@export var popupTime:float = 0
@export var pickupPopupSprite: Sprite2D 

var item : Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.monitorable = true
	self.monitoring = true
	self.body_entered.connect(self.getPickedUp)
	
	#Play the idle animation
	self.animationPlayer.play("IDLE")
	pass # Replace with function body.


func setData( item: Item) -> void:
	self.item = item

func getPickedUp( body: Node2D) -> void:
	
	#Play the PickedUp animation
	if(body is Player):
		self.collisionShape2D.disabled = true 
		self.animationPlayer.play("PICKUP")

		var itemUseContext =  ItemUseContext.new()
		itemUseContext.actor = body
		
		for effect: ItemEffect in self.item.ItemEffects:
			effect.apply( itemUseContext )
			
		var playerEntry = Game.getPlayerEntry(body.player_index)
		var stat = playerEntry.stats.getStat(PlayerStats.STATKEY_ITEMS_COLLECTED)
		playerEntry.stats.setStat(PlayerStats.STATKEY_ITEMS_COLLECTED, stat + 1)	
	
	
		await get_tree().create_timer( self.animationPlayer.get_animation("PICKUP").length).timeout
		self.queue_free()



func applyItem() -> void:
	if(self.item != null) :
		self.sprite2D.texture = self.item.ingameIcon
		#also set collision shape later
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	pass
