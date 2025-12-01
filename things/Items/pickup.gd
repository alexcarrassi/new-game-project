class_name Pickup extends Area2D

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

var pickupData : PickupData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.monitorable = true
	self.monitoring = true
	self.body_entered.connect(self.getPickedUp)
	pass # Replace with function body.


func setData( pickupData: PickupData) -> void:
	self.pickupData = pickupData

func getPickedUp( body: Node2D) -> void:
	if(body is Player): 
		print("Player!")
		for effect: PickupEffect in self.pickupData.pickupEffects:
			effect.apply( body )
		
		
		self.queue_free()	


func applyPickupData() -> void:
	if(self.pickupData != null) :
		self.sprite2D.texture = self.pickupData.icon
		#also set collision shape later
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
