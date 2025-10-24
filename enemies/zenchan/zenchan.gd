class_name Zenchan extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 400.0

var direction: Vector2 = Vector2.LEFT

@export var MAX_FALL_VELOCITY = 100.0
@export var gravity_multiplier = 1.0
@export var MAX_RISE_VELOCITY = 400.0
@export var RUN_SPEED = 100.0

@onready var sm_locomotion: StateMachine_Locomotion_Enemy = $StateMachine_Locomotion_Enemy
@onready var animationPlayer: AnimationController = $AnimationPlayer
@onready var sprite2D: Sprite2D = $Sprite2D
@onready var sensors: Node2D = $Sensors
#@onready var sm_locomotion: StateMachine_Locomotion_Enemy = $StateMachine_Locomotion_Enemy

func _ready() -> void:
	#self.animationPlayer.sm_locomotion = self.sm_locomotion
	self.floor_snap_length = 6.0
	self.sm_locomotion.state_transitioned.connect( self.animationPlayer.onStateTransition)	
	$Sensors.scale.x = self.direction.x
	pass
	
	
func update_senses() -> void:
	
	var sensor_wall_front = $Sensors/Wall_front as RayCast2D
	if( sensor_wall_front).is_colliding(): 
		print("FLIP")
		self.direction.x *= -1
		$Sensors.scale.x *= -1
		
func _physics_process(delta: float) -> void:

	self.update_senses()
	pass
