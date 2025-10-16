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
var locomotionState: LocomotionState = LocomotionState.GROUNDED
var actState: ActState = ActState.NONE

@onready var locoState: StateMachine_Locomotion = $StateMachine_Locomotion


var oneShot_animation_locked = false

func freeAnimationLock() -> void: 
	self.oneShot_animation_locked = false

func _ready() -> void:
	self.up_direction = Vector2.UP
	self.floor_max_angle = deg_to_rad(45)
	self.floor_snap_length = 6.0
	
	
func exposeInputSnapshot() -> String:
	var inputSnapshot = self.inputState.toString()
	
	var buffersSnapshot = "buffers[jump: %.5f , attack: %.2f]" % [self.buffer_times["jump"], self.buffer_times["attack"]]
	
	var coyote = "coyote: %.2f" % [self.coyote_time]
	
	var speedSnapshot = "speed h: %.2f  ,  speed v: %.2f" % [self.velocity.x, self.velocity.y] 
	
	var stateSnapShot = "loco: %s ,  act: %s" % [self.locomotionState, self.actState]
	
	var animation = "locked: %s , animation: %s" % [self.oneShot_animation_locked, self.animationPlayer.current_animation]
	
	return inputSnapshot + "\n" + buffersSnapshot + "\n" + coyote + "\n" + speedSnapshot + "\n" + stateSnapShot + "\n" + animation

		
func move_horizontal(delta: float, accel: float, decel: float) -> void :		
	var targetSpeed = inputState.haxis * self.max_run_speed
	var rate = accel if abs(inputState.haxis) > 0.0 else decel 
	# turn boost
	# If our current targetSpeed and Velocity are in opposite directions
	if( targetSpeed * rate < 0.0): 
	#if signi( targetSpeed ) != 0 and signi(self.velocity.x) != 0 and (signi(targetSpeed) != signi(self.velocity.x)):
		rate *= 3
	
	self.velocity.x = move_toward(self.velocity.x, targetSpeed, rate * delta)
			
			
func handle_animation() -> void: 
	if( self.velocity.x != 0):
		self.sprite2D.flip_h = self.velocity.x < 0

	if( self.oneShot_animation_locked):
		return 
		
	var animation = "movement/idle"
	match( self.locomotionState):
		LocomotionState.GROUNDED:
			if( abs(self.velocity.x) > 0.0) :
				animation = "movement/run"
			else:
				animation = "movement/idle"	
			pass
		LocomotionState.RISING:
			animation = "movement/jump_rise"
			pass
		LocomotionState.FALLING:
			animation = "movement/jump_fall"
			pass
	
	if( not self.animationPlayer.current_animation == animation ):
		self.animationPlayer.play(animation) 
		

func spit_bubble() -> void:
	#self.animationPlayer.queue_free()
	self.actState = ActState.ATTACK
	self.animationPlayer.play("act/attack")
	self.oneShot_animation_locked = true
	pass

func end_attack() -> void: 
	self.actState = ActState.NONE	
	
	
				
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
		self.buffer_times["attack"] =max(0, self.buffer_times["attack"] - delta)
	
	#State logic (State your intentions)
	
	
	#ACT
	match(self.actState):
		ActState.NONE:
			
			if(self.buffer_times["attack"] > 0.0) :
				#consume and perform the attack
				self.buffer_times["attack"] = 0
				self.spit_bubble()	
			pass

		ActState.ATTACK:
			#countdown? Not sure.
			pass	
	
	#
	##LOCOMOTION
	#match(self.locomotionState) :
		#LocomotionState.GROUNDED:
			#self.gravity_multiplier = 1.0
			## horizontal movement
			#self.move_horizontal(delta, self.ground_accel, self.ground_decel)
#
			## jumping
			#if( self.buffer_times['jump'] > 0.0 && self.coyote_time > 0.0) :
				#self.animationPlayer.play("movement/jump_rise_start")
				#self.oneShot_animation_locked = true
				#self.velocity.y = -self.jump_force
				#self.buffer_times['jump'] = 0
				#self.coyote_time = 0
			#pass	
		#LocomotionState.RISING:
			#self.gravity_multiplier = self.gravity_multiplier_rising
			#self.move_horizontal(delta, self.air_accel, self.air_decel)
			#
			#pass
		#LocomotionState.FALLING:
			#self.gravity_multiplier = self.gravity_multiplier_falling
			#self.move_horizontal(delta, self.air_accel, self.air_decel)
			#
						## jumping
			#if( self.buffer_times['jump'] != 0 && self.coyote_time != 0) :
				#self.animationPlayer.play("movement/jump_rise_start")
				#self.oneShot_animation_locked = true
#
				#self.velocity.y = -self.jump_force
				#self.buffer_times['jump'] = 0
				#self.coyote_time = 0
			#pass			
			#
	##Physics integrations
	#self.velocity.y += self.get_gravity().y * self.gravity_multiplier * delta
	#self.velocity.y = clamp(self.velocity.y, -self.max_rise_speed, self.max_fall_speed)
#
#
	#self.move_and_slide()
	#
	##Read facts and decide current state
	#if(  self.is_on_floor() ):
		#self.locomotionState = LocomotionState.GROUNDED
	#else: 
		#if(self.velocity.y < 0): 
			#self.locomotionState = LocomotionState.RISING 
		#else :
			#self.locomotionState = LocomotionState.FALLING	
	#
	##Update late timers (physics dependant)
	##coyote
	#if( self.locomotionState == LocomotionState.GROUNDED):
		#self.coyote_time = coyote_max
	#else :
		#self.coyote_time = max(0, self.coyote_time - delta)	
		#
	##State transition
	#
	##animate
	#self.handle_animation()

		
enum LocomotionState{ 
	GROUNDED, RISING, FALLING
}

enum ActState{
	NONE, ATTACK
}

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
		s.attack = Input.is_action_pressed("attack")
		
		return s
		
	func toString() -> String:
		return "haxis: %.2f, vaxis: %.2f attack: %s \n jump[pressed:%s, held: %s]  "	 % [
			self.haxis,
			self.vaxis,
			self.attack,
			self.jump_pressed,
			self.jump_held
		]
