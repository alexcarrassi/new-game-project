class_name PlayerBubble extends Bubble


@export var actorTimerOffset = 3.0

@onready var popTimer: Timer = $PopTimer
@onready var prePopTimer: Timer = $PrepopTimer
@onready var redTimer: Timer = $RedTimer


var is_red: bool = false
var actor: Actor
var actor_parent: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	self.get_tree().create_timer( animationPlayer.get_animation("EXPAND").length  ).timeout.connect( self.setFloating)
	self.animationPlayer.play("EXPAND")
	
	self.hitbox.area_entered.connect( self.hitBoxAreaEntered )
	
	
	self.popTimer.timeout.connect( self.autoPop)
	self.prePopTimer.timeout.connect( self.prePop )
	self.redTimer.timeout.connect( self.setRed )
	
	
	super._ready()
	pass # Replace with function body.

		
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


func hitBoxAreaEntered(area: Area2D) -> void:
	
	var areaOwner = area.get_parent()
	
	if( self.is_active and self.actor == null and areaOwner is Enemy) :
		
		if(areaOwner.get_groups().any(func(group) -> bool:
			return group == "Invulnerable"
		)) :
			return

		self.actor = areaOwner
		self.actor.sm_status.state.finished.emit("ALIVE")
		self.actor.sm_locomotion.state.finished.emit("BUBBLED")
		
		self.actor_parent = self.actor.get_parent()
		self.actor.reparent(self)
		self.actor.position = Vector2.ZERO
		self.sprite.visible = false
		self.setFloating()
		
		self.hitbox.call_deferred("set_monitoring", false)
		self.hitbox.monitoring = false
		
	pass
	
func setFloating() -> void:
	super.setFloating()

	self.redTimer.start()
	self.prePopTimer.start()
	self.popTimer.start()

	#Add time to the timers if an actor has been captured in the bubble
	for the_timer: Timer in [self.redTimer, self.prePopTimer, self.popTimer]:
		the_timer.wait_time += self.actorTimerOffset
		
		
func float_x(delta: float) -> Vector2:
	self.set_collision_mask_value(4, true) # Collide with other bubbles now

	var distance = (self.destination.position - self.position)
	var velocity = distance * Vector2(self.float_hor_speed, self.float_vert_speed)
	velocity.x = clamp(velocity.x, -self.float_hor_speed, self.float_hor_speed)
	velocity.y = clamp(velocity.y, -self.float_vert_speed, self.float_vert_speed)
	
	#var alpha = 1.0 - pow(0.001, delta / max(0.0001, 0.15))

	return velocity

	#the bigger the difference, the bigger the velocity. Capped
	#velocity = distance * max_speed 
	#at some point, the distance should be clamped to 0. So if smaller than 0.1, it should be 0


func float_y(delta: float) -> Vector2:
	return Vector2(0, -self.float_vert_speed)

func _physics_process(delta: float) -> void:
	
	match self.state: 
		BubbleState.Popping:
			self.target_velocity = Vector2.ZERO
			return
		BubbleState.Shooting:
			if(self.is_active) :
				self.target_velocity.x = dir.x * self.hor_speed
		BubbleState.Floating:
			if(self.destination != null) :		
				if(self.position.y > self.destination.position.y):
					self.target_velocity = self.float_y(delta)	
				else:
					self.target_velocity = self.float_x(delta) 	
	
	
	# Give the Hurtbox a slight Lag, behind our overall position
	var local_v = self.linear_velocity.rotated( -self.global_rotation )
	var target = (-local_v * 0.2).limit_length(3)   #computes the desired offset. Max 4 pixels in total.
	
	# Smoothly approach target
	var follow_speed = 80.0
	var a := 1.0 - exp(-follow_speed * delta)
	hurtboxOffset = hurtboxOffset.lerp(target, a)
	self.hurtbox.position = hurtboxOffset
	
	

	
