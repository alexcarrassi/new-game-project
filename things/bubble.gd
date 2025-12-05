class_name Bubble extends RigidBody2D

@export var hor_speed: float = 300.0
@export var float_vert_speed: float = 30.0
@export var float_hor_speed: float = 30.0
@export var actorTimerOffset = 3.0

@onready var popTimer: Timer = $PopTimer
@onready var prePopTimer: Timer = $PrepopTimer
@onready var redTimer: Timer = $RedTimer


@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var sprite: Sprite2D = $Sprite2D
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var infoLabel: Label = $DebugLayer/info

enum BubbleState { Shooting, Floating, Popping }
var state = BubbleState.Shooting

var destination: Node2D
var dir: Vector2 = Vector2.RIGHT
var is_active: bool = true
var is_popping: bool = false
var is_red: bool = false
var actor: Actor
var actor_parent: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.hitbox.monitoring = true 
	self.hitbox.monitorable = true 
	self.get_tree().create_timer( animationPlayer.get_animation("EXPAND").length  ).timeout.connect( self.setFloating)
	self.animationPlayer.play("EXPAND")
	
	self.hitbox.body_entered.connect( self.onBodyEntered )
	self.hurtbox.body_entered.connect( self.onHurtboxBodyEntered )
	self.collisionShape.disabled = false
	self.set_collision_mask_value(4, false) #Don't collide with other bubble yet
	self.gravity_scale = 0
	
	
	self.popTimer.timeout.connect( self.autoPop)
	self.prePopTimer.timeout.connect( self.prePop )
	self.redTimer.timeout.connect( self.setRed )
	pass # Replace with function body.

func onHurtboxBodyEntered( body: Node2D) -> void:
	
	if( self.state == BubbleState.Floating and body is Player):
		var player = body as Player
		#popping direction is determine by position of player compared to bubble
		self.dir.x = 1 if(body.position.x <self.position.x) else -1
		self.playerPop()

		
func prePop() -> void:
	self.animationPlayer.play("RED_FLICKER")
	
func setRed() -> void:
	self.is_red = true
	self.animationPlayer.play("RED")
	if(self.actor != null ) :
		self.actor.sm_status.state.finished.emit("RED")

	
# Timer-triggered pop	
func autoPop() -> void:
	self.pop()
	self.releaseActor()
	pass
	
		
func pop() -> void:
	self.state = BubbleState.Popping

	self.sprite.visible = true
	self.linear_velocity = Vector2.ZERO
	var popAnimation =  self.animationPlayer.get_animation("PON")
	self.get_tree().create_timer( popAnimation.length).timeout.connect( func (): 
		queue_free() 
	)
	self.animationPlayer.play("PON")

# Player-triggered pop	
func playerPop() -> void:
	self.pop()
	self.killActor()
	
func releaseActor() -> void:
		if(self.actor != null):
			self.actor.reparent( self.actor_parent)
			self.actor.sm_locomotion.state.finished.emit("IDLE")
			self.actor.rotation = 0

	
func killActor() -> void:
	if(self.actor != null) :
		self.actor.reparent( self.actor_parent )
		self.actor.sm_locomotion.state.finished.emit("FALLING")
		self.actor.sm_status.state.finished.emit("DEAD", {"dir": self.dir.x})
		self.actor.rotation = 0


func onBodyEntered(body: Node2D) -> void:
	if( self.is_active and self.actor == null and body is Actor) :
		
		if(body.get_groups().any(func(group) -> bool:
			return group == "Invulnerable"
		)) :
			return
			
			
		print("BODY ENTERED")

		#self.queue_free()
		#todo: do not capture already capture actors
		self.actor = body
		self.actor.sm_locomotion.state.finished.emit("BUBBLED")
		self.actor.sm_status.state.finished.emit("ALIVE")
		
		self.actor_parent = self.actor.get_parent()

		self.actor.reparent(self)
		self.actor.position = Vector2.ZERO
		self.actor.loco_locked = true
		self.actor.act_locked = true
		self.sprite.visible = false
		self.setFloating()
		
	pass
	
func setFloating() -> void:
	self.state = BubbleState.Floating
	self.hitbox.monitoring = false
	self.collisionShape.disabled = false
	self.hurtbox.monitoring = true
	
	self.redTimer.start()
	self.prePopTimer.start()
	self.popTimer.start()
	
	
	#Add time to the timers if an actor has been captured in the bubble
	for the_timer: Timer in [self.redTimer, self.prePopTimer, self.popTimer]:
		the_timer.wait_time += self.actorTimerOffset
		
func pop_silent() -> void:
	pass
		
func float_x(delta: float) -> void:
	self.set_collision_mask_value(4, true) # Collide with other bubbles now

	var distance = (self.destination.position - self.position)
	var velocity = distance * Vector2(self.float_hor_speed, self.float_vert_speed)
	velocity.x = clamp(velocity.x, -self.float_hor_speed, self.float_hor_speed)
	velocity.y = clamp(velocity.y, -self.float_vert_speed, self.float_vert_speed)
	
	#var alpha = 1.0 - pow(0.001, delta / max(0.0001, 0.15))

	self.linear_velocity = velocity

	#the bigger the difference, the bigger the velocity. Capped
	#velocity = distance * max_speed 
	#at some point, the distance should be clamped to 0. So if smaller than 0.1, it should be 0


func float_y(delta: float) -> void:
	self.linear_velocity = Vector2(0, Vector2.UP.y * self.float_vert_speed)

func _physics_process(delta: float) -> void:
	
	match self.state: 
		BubbleState.Popping:
			self.linear_velocity = Vector2.ZERO
			return
		BubbleState.Shooting:
			if(self.is_active) :
				self.linear_velocity.x = dir.x * self.hor_speed
		BubbleState.Floating:
			if(self.destination != null) :		
				if(self.position.y > self.destination.position.y):
					self.float_y(delta)	
				else:
					self.float_x(delta) 	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.sprite.rotation = -self.rotation

	$DebugLayer.rotation = -self.rotation
	$DebugLayer.position = Vector2.ZERO
	
	
	self.infoLabel.text = "(%.2f, %.2f)" % [self.linear_velocity.x, self.linear_velocity.y]
	
