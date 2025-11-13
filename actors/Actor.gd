class_name Actor extends CharacterBody2D

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var sm_locomotion: StateMachine_Locomotion = $StateMachine_Locomotion
@onready var sm_status: StateMachine_Status = $StateMachine_Status

@export var GRAVITY_MULTIPLIER = 1.0
@export var GRAVITY_MULTIPLIER_RISING: float = 1.0
@export var GRAVITY_MULTIPLIER_FALLING: float = 2.0
@export var JUMP_VELOCITY: float = 10.0
@export var MAX_RUN_VELOCITY: float = 200.0
@export var MAX_FALL_VELOCITY: float = 100.0
@export var MAX_RISE_VELOCITY: float = 350.0

@export var Bubble_Destination: Node2D
@export var FLOAT_SPEED: float = 30.0


@export var LootTable : Array[PickupData] = []
@export var pickup : PackedScene
	




var direction: Vector2 = Vector2.LEFT

var act_locked = false
var loco_locked = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.up_direction = Vector2.UP
	self.floor_max_angle = deg_to_rad(45)
	self.floor_snap_length = 6.0

	self.sm_locomotion.state_transitioned.connect( self.animationPlayer.onStateTransition)	
	self.sm_status.state_transitioned.connect(  self.animationPlayer.onStateTransition)

func instantiateLoot() -> Pickup:
	
	# We'd normally do a weighted lookup, but right now, just get the first available one
	if(self.LootTable.size() > 0):

		var newPickup : Pickup = pickup.instantiate()
		var pickupData = self.LootTable[0]

		get_tree().root.add_child( newPickup )
		newPickup.setData( pickupData )
		newPickup.applyPickupData()
		newPickup.position = self.position
		
		return newPickup
		
	return null	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
