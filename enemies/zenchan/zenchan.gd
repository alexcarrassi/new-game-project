class_name Zenchan extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var MAX_FALL_VELOCITY = -200.0
@export var gravity_multiplier = 1.0
@export var MAX_RISE_VELOCITY = 400.0

@onready var sm_locomotion: StateMachine_Locomotion_Enemy = $StateMachine_Locomotion_Enemy
@onready var animationPlayer: AnimationController = $AnimationPlayer
#@onready var sm_locomotion: StateMachine_Locomotion_Enemy = $StateMachine_Locomotion_Enemy

func _ready() -> void:
	#self.animationPlayer.sm_locomotion = self.sm_locomotion
	
	
	self.sm_locomotion.state_transitioned.connect( self.animationPlayer.onStateTransition)	
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()
