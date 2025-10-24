class_name Player extends CharacterBody2D
#ITSIMSCET  
@onready var sprite2D: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

@export var ground_accel: float = 2800.0
@export var ground_decel: float = 3000.0
@export var max_run_speed: float = 200.0
@export var air_accel: float = 2000.0
@export var air_decel: float = 3000.0


@export var jump_force: float = 10.0

@export var coyote_max: float = 0.1
var coyote_time: float = 0.0

@export var jump_held_max: float = 3.0
var jump_held_time: float = 0.0

@export var buffers : Dictionary = {"jump" = 0.05, "attack" = 0.1 }
var buffer_times : Dictionary = {"jump" = 0.0, "attack" = 0.0}

@export var gravity_multiplier_rising: float = 0.8
@export var gravity_multiplier_falling: float = 2.0
@export var max_fall_speed: float = 300.0
@export var max_rise_speed: float = 200.0

var gravity_multiplier: float = 1.0



var inputState: InputState

@onready var locomotionState: StateMachine_Locomotion = $StateMachine_Locomotion
@onready var actState: StateMachine_Act = $StateMachine_Act

var oneShot_animation_locked = false

func freeAnimationLock() -> void: 
	self.oneShot_animation_locked = false

func _ready() -> void:
	self.up_direction = Vector2.UP
	self.floor_max_angle = deg_to_rad(45)
	self.floor_snap_length = 6.0
	
	self.locomotionState.state_transitioned.connect( self.animationPlayer.onStateTransition)	
	self.actState.state_transitioned.connect( self.animationPlayer.onStateTransition)
	
func exposeInputSnapshot() -> String:
	var inputSnapshot = self.inputState.toString()
	
	var buffersSnapshot = "buffers[jump: %.5f , attack: %.2f]" % [self.buffer_times["jump"], self.buffer_times["attack"]]
	
	var coyote = "coyote: %.2f" % [self.coyote_time]
	
	var speedSnapshot = "speed h: %.2f  ,  speed v: %.2f" % [self.velocity.x, self.velocity.y] 
	
	var stateSnapShot = "loco: %s ,  act: %s" % [self.locomotionState.state.name, self.actState.state.name]
	
	var animation = "locked: %s , animation: %s" % [self.animationPlayer.animationLock != null, self.animationPlayer.current_animation]
	
	return inputSnapshot + "\n" + buffersSnapshot + "\n" + coyote + "\n" + speedSnapshot + "\n" + stateSnapShot + "\n" + animation
				
func _physics_process(delta: float) -> void:
	
	#Get Input snapshot
	self.inputState = InputState.snapShot()
	
	#Update early timers (based on Input, preparing for state logic)
		#jump timer
	
		#buffers
	if(self.inputState.jump_pressed):
		self.buffer_times["jump"] = buffers["jump"]			
	else :
		self.buffer_times["jump"] = max(0, self.buffer_times["jump"] - delta)
	
	
	if(self.inputState.attack):
		self.buffer_times["attack"] = buffers["attack"]
	else:
		self.buffer_times["attack"] = max(0, self.buffer_times["attack"] - delta)
	
	#State logic (State your intentions)
	
	



class InputState:
	var haxis: float = 0.0
	var vaxis: float = 0.0
	
	var right: bool = false
	var down: bool = false
	var left: bool = false
	var up: bool = false
	
	var jump_pressed: bool = false
	var jump_held: bool = false
	var attack: bool = false
	
	static func snapShot() -> InputState:
		var s = InputState.new()
		
		s.haxis = Input.get_axis("ui_left", "ui_right")
		s.vaxis = Input.get_axis("ui_down", "ui_up")
		
		s.right = Input.is_action_pressed("ui_right")
		s.down = Input.is_action_pressed("ui_down")
		s.left = Input.is_action_pressed("ui_left")
		s.up = Input.is_action_pressed("ui_up")
		
		s.jump_pressed = Input.is_action_just_pressed("ui_jump")
		s.jump_held = Input.is_action_pressed("ui_jump")
		s.attack = Input.is_action_just_pressed("attack")
		
		return s
		
	func toString() -> String:
		return "haxis: %.2f, vaxis: %.2f attack: %s \n jump[pressed:%s, held: %s]  "	 % [
			self.haxis,
			self.vaxis,
			self.attack,
			self.jump_pressed,
			self.jump_held
		]
