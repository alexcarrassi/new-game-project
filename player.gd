class_name Player
extends CharacterBody2D
#ITSIMSCET  
@onready var sprite2D = $Sprite2D

@export var coyote_time = 0.1
@export var jump_timer = 3.0
@export var jump_force = 10.0

var coyote_max = 0.0
var jump_time_max = 0.0

var inputState: InputState
var state: CharacterState = CharacterState.GROUNDED

func _ready() -> void:
	self.up_direction = Vector2.UP
	self.floor_max_angle = deg_to_rad(45)
	self.floor_snap_length = 6.0
	
func exposeInputSnapshot() -> String:
	return self.inputState.toString()
		
func _physics_process(delta: float) -> void:
	
	#Get Input snapshot
	self.inputState = InputState.snapShot()
	
	#Update timers (based on Input, preparing for state logic)
	#coyote timer
	#jump timer
	# coyote timer. Wont work like this, because we need to know if we're falling because we jumped or not
	self.coyote_time = self.coyote_time + delta if state == CharacterState.FALLING else 0 
	
	#State logic (State your intentions)
	
	#Physics integrations
	
	self.move_and_slide()
	
	#Read facts and decide current state
	
	#State transition
	
	#animate
	
		
		
enum CharacterState{ 
	GROUNDED, RISING, FALLING
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
		return "haxis: %.2f, vaxis: %.2f \n jump[pressed:%s, held: %s]"	 % [
			self.haxis,
			self.vaxis,
			self.jump_pressed,
			self.jump_held
		]
