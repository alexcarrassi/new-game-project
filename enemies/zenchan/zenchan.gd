class_name Zenchan extends CharacterBody2D


const SPEED = 300.0

var direction: Vector2 = Vector2.LEFT

@export var MAX_FALL_VELOCITY = 100.0
@export var gravity_multiplier = 1.0
@export var MAX_RISE_VELOCITY = 400.0
@export var RUN_SPEED = 100.0
@export var DECISION_PERIOD = 0.33
@export var JUMP_VELOCITY = 350.0

@onready var sm_locomotion: StateMachine_Locomotion_Enemy = $StateMachine_Locomotion_Enemy
@onready var animationPlayer: AnimationController = $AnimationPlayer
@onready var sprite2D: Sprite2D = $Sprite2D
@onready var sensors: Node2D = $Sensors

@onready var decision_timer: Timer = $Decision_Timer
var rng = RandomNumberGenerator.new()
#@onready var sm_locomotion: StateMachine_Locomotion_Enemy = $StateMachine_Locomotion_Enemy

func _ready() -> void:
	#self.animationPlayer.sm_locomotion = self.sm_locomotion
	self.floor_snap_length = 6.0
	self.sm_locomotion.state_transitioned.connect( self.animationPlayer.onStateTransition)	
	$Sensors.scale.x = self.direction.x
	
	self.rng.randomize()
	self.decision_timer.wait_time = self.DECISION_PERIOD
	self.decision_timer.one_shot = true
	pass
	
	
func decison_timed() -> void:
	# Check the players vs own.
	pass	
	
func player_above() -> int:
	var player = get_tree().get_first_node_in_group("player") as Player
	var player_y = player.position.y
	var margin = 12.0
	
	if( player.position.y < self.position.y - margin) :
		return 1
	elif( player.position.y > self.position.y + margin )	:
		return -1
	else :
		return 0	
 
	pass
	
func wall_ahead() -> bool:
	var sensor_wall_front = $Sensors/Wall_front as RayCast2D
	return sensor_wall_front.is_colliding()
	 
func floor_above() -> bool: 
	var sensor_floor_above = $Sensors/Floor_above as RayCast2D
	return sensor_floor_above.is_colliding()

func floor_front() -> bool:
	var sensor_floor_front = $Sensors/Floor_front as RayCast2D 
	return sensor_floor_front.is_colliding()
	
	
func flip() -> void:
	var sensor_wall_front = $Sensors/Wall_front as RayCast2D
	var sensor_floor_front = $Sensors/Floor_front as RayCast2D 
	
	self.direction.x *= -1
	sensor_wall_front.position.x *= -1
	sensor_wall_front.target_position.x *= -1
	sensor_floor_front.position.x *= -1
	self.sprite2D.flip_h = self.direction.x > 0.0

	#self.sprite2D.flip_h
	
	
		
func _physics_process(delta: float) -> void:
	pass
