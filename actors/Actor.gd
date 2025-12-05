class_name Actor extends CharacterBody2D

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var animationPlayer: AnimationController = $AnimationPlayer
@onready var sm_locomotion: StateMachine_Locomotion = $StateMachine_Locomotion
@onready var sm_status: StateMachine_Status = $StateMachine_Status
@onready var collisionShape: CollisionShape2D = $CollisionShape2D

@export var DECISION_PERIOD = 0.33

var modController: ModController 

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
		
@export var health: int = 3


var direction: Vector2 = Vector2.LEFT

var act_locked = false
var loco_locked = false 

signal actorDeath(actor: Actor) 
signal actorHurt(actor: Actor)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.up_direction = Vector2.UP
	self.floor_max_angle = deg_to_rad(45)
	self.floor_snap_length = 6.0

	self.sm_locomotion.state_transitioned.connect( self.animationPlayer.onStateTransition)	
	self.sm_status.state_transitioned.connect(  self.animationPlayer.onStateTransition)
	
	self.modController = ModController.new()
	self.modController.actor = self
		
func _physics_process(delta: float) -> void:
	self.modController.tick(delta)

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
	
func post_move_and_slide() -> void:
	pass	
	
func onPlayerCollide( player: Player) -> void:
	print("ACTOR")
	pass	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.modController.tick_process(delta)
	pass
