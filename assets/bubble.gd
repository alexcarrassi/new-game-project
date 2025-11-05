class_name Bubble extends RigidBody2D

@export var hor_speed: float = 300.0
@export var float_vert_speed: float = 30.0
@export var float_hor_speed: float = 30.0

@onready var timer: Timer = $Timer
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D
@onready var hurtbox: CollisionShape2D = $CollisionShape2D
@onready var infoLabel: Label = $DebugLayer/info

var destination: Node2D
var dir: Vector2 = Vector2.RIGHT
var is_active: bool = true

var actor: Actor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.hitbox.monitoring = true 
	self.hitbox.monitorable = true 
	self.timer.one_shot = true 
	self.timer.wait_time = animationPlayer.get_animation("EXPAND").length
	self.timer.start()
	
	self.timer.timeout.connect( self.setInactive)
	self.animationPlayer.play("EXPAND")
	
	self.hitbox.body_entered.connect( self.onBodyEntered )
	self.hurtbox.disabled = true
	self.gravity_scale = 0
	
	
	print(self.hitbox)
	#connect("body_entered", Callable(self, "_on_body_entered"))
	#connect("area_entered", Callable(self, "_on_area_entered"))
	
	pass # Replace with function body.

func onBodyEntered(body: Node2D) -> void:
	if( self.is_active and body is Actor) :
		body.sm_locomotion.state.finished.emit("BUBBLED")
		#self.queue_free()
		
		self.actor = body
		self.actor.reparent(self)
		self.actor.position = Vector2.ZERO
		self.sprite.visible = false
		self.setInactive()
	pass
	
func setInactive() -> void:
	self.is_active = false	
	self.hurtbox.disabled = false
	
func pop_silent() -> void:
	pass
		
func float_x(delta: float) -> void:
	#self.global_position.y += Vector2.UP.y * self.vert_speed * delta
	
	var distance = (self.destination.position - self.position)
	var velocity = distance * Vector2(self.float_hor_speed, self.float_vert_speed)
	velocity.x = clamp(velocity.x, -self.float_hor_speed, self.float_hor_speed)
	velocity.y = clamp(velocity.y, -self.float_vert_speed, self.float_vert_speed)
	
	var alpha = 1.0 - pow(0.001, delta / max(0.0001, 0.15))

	self.linear_velocity = velocity

	#the bigger the difference, the bigger the velocity. Capped
	#velocity = distance * max_speed 
	#at some point, the distance should be clamped to 0. So if smaller than 0.1, it should be 0


func float_y(delta: float) -> void:
	self.linear_velocity = Vector2(0, Vector2.UP.y * self.float_vert_speed)

func _physics_process(delta: float) -> void:
	if(self.is_active) :
		self.linear_velocity.x = dir.x * self.hor_speed
		#self.global_position.x += dir.x * self.hor_speed * delta 
	elif(self.destination != null) :	
		
		if(self.position.y > self.destination.position.y):
			self.float_y(delta)	
		else:
			self.float_x(delta) 	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.sprite.rotation = -self.rotation
	$DebugLayer.rotation =- self.rotation
	self.infoLabel.text = "(%.2f, %.2f)" % [self.linear_velocity.x, self.linear_velocity.y]
	
