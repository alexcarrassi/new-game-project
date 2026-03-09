class_name ItemPickup extends CharacterBody2D

@onready var sprite2D: Sprite2D = $Sprite_World
@onready var spritePickup: Sprite2D = $Sprite_Pickup
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hurtBox: Area2D  = $Hurtbox



@export var fallingspeed :float = 200.0
@export var disableCollision: bool = false

var item : Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	hurtBox.monitorable = true
	hurtBox.monitoring = true
	
	#Play the idle animation
	self.applyItem()
	self.setData(self.item)
	self.animationPlayer.play("IDLE")

	hurtBox.body_entered.connect(self.getPickedUp)
	
	#if(disableCollision):
		#set_collision_mask_value(1, false)
		#set_collision_mask_value(8, false)

	
	pass # Replace with function body.


	self.animationPlayer.current_animation

func setData( item: Item) -> void:
	self.item = item
	self.sprite2D.texture = self.item.ingameIcon
	self.sprite2D.region_rect = Rect2i(Vector2i.ZERO, self.item.ingameIcon.region.size)

func getPickedUp( body: Node2D) -> void:
	
	#Play the PickedUp animation
	if(body is Player):
		self.collisionShape2D.disabled = true 
		self.animationPlayer.play("PICKUP")

		var itemUseContext =  ItemUseContext.new()
		itemUseContext.actor = body
		itemUseContext.itemPickup = self
		itemUseContext.item = self.item
		itemUseContext.usedAtPosition = position
		
		#item.
		for effect: ItemEffect in self.item.ItemEffects:
			itemUseContext.usedAtPosition = position
			effect.apply( itemUseContext )
			
		var playerEntry = Game.getPlayerEntry(body.player_index)
		var stat = playerEntry.stats.getStat(PlayerStats.STATKEY_ITEMS_COLLECTED)
		playerEntry.stats.setStat(PlayerStats.STATKEY_ITEMS_COLLECTED, stat + 1)	
		
		
		self.fallingspeed = 0
		velocity = Vector2.ZERO

		await get_tree().create_timer( self.animationPlayer.get_animation("PICKUP").length).timeout
		self.queue_free()



func applyItem() -> void:
	if(self.item != null) :
		pass
		#also set collision shape later
		

func _physics_process(delta: float) -> void:
	velocity.x = 0
	if(fallingspeed == 0):
		pass
	velocity.y += get_gravity().y * delta * fallingspeed 
	velocity.y = clamp( velocity.y, -fallingspeed, fallingspeed)
	
	#
	#self.body.velocity.y += self.body.get_gravity().y * self.body.GRAVITY_MULTIPLIER * delta
	#self.body.velocity.y = clamp(self.body.velocity.y, -self.body.MAX_RISE_VELOCITY, self.body.MAX_FALL_VELOCITY)

	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(self.spritePickup.visible):
		pass
	pass
