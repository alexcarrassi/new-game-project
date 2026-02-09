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
func playerPop(player: Player) -> void:
	super.playerPop(player)
	self.pop()
	var actor = self.killActor()
	if(actor):
		player.addToCombo(actor)
		
	
	
func releaseActor() -> Actor:
		if(self.actor != null):
			self.actor.reparent( self.actor_parent)
			self.actor.sm_locomotion.state.finished.emit("IDLE")
			self.actor.rotation = 0
		return self.actor	

	
func killActor() -> Actor:
	if(self.actor != null) :
		self.actor.reparent( self.actor_parent )
		self.actor.sm_locomotion.state.finished.emit("FALLING")
		self.actor.sm_status.state.finished.emit("DEAD", {"dir": self.dir.x})
		self.actor.rotation = 0
	return self.actor	


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
		
	super.hitBoxAreaEntered(area)
	
func setFloating() -> void:
	super.setFloating()

	self.redTimer.start()
	self.prePopTimer.start()
	self.popTimer.start()

	#Add time to the timers if an actor has been captured in the bubble
	for the_timer: Timer in [self.redTimer, self.prePopTimer, self.popTimer]:
		the_timer.wait_time += self.actorTimerOffset
		
func _physics_process(delta: float) -> void:
	
	match self.state: 
		BubbleState.Popping:
			self.target_velocity = Vector2.ZERO
			return
		BubbleState.Shooting:
			if(self.is_active) :
				self.target_velocity.x = dir.x * self.hor_speed
		BubbleState.Floating:
			self.target_velocity = self.float(delta)
	
	self.hurtbox_update(delta)

	

	
