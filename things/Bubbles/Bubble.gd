class_name Bubble extends RigidBody2D

@export var hor_speed: float = 300.0
@export var float_vert_speed: float = 30.0
@export var float_hor_speed: float = 30.0

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var sprite: Sprite2D = $Sprite2D
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var infoLabel: Label = $DebugLayer/info

var poppedBy: Player

var lock_force_damp : bool = false

enum BubbleState { Shooting, Floating, Popping }
var state = BubbleState.Shooting


var destination: Node2D
var dir: Vector2 = Vector2.RIGHT
var is_active: bool = true
var is_popping: bool = false

var hurtboxOffset = Vector2.ZERO
var target_velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.hitbox.monitoring = true 
	self.hitbox.monitorable = true 
	
	self.hurtbox.body_entered.connect( self.onHurtboxBodyEntered )
	self.hitbox.area_entered.connect( self.hitBoxAreaEntered )
	self.hitbox.body_entered.connect(self.hitBoxBodyEntered )

	self.hurtbox.monitorable = false
	self.hurtbox.monitoring = false

	self.gravity_scale = 0
	
func onHurtboxBodyEntered( body: Node2D) -> void:
	if( self.state == BubbleState.Floating and body is Player):
		var player = body as Player
		#popping direction is determine by position of player compared to bubble
		self.dir.x = 1 if(body.position.x <self.position.x) else -1
		self.playerPop( player )
		self.poppedBy = player
		
		


func toggle_collision(toggle: bool) -> void:
	self.set_collision_mask_value(4, toggle) #Collide with other bubbles
	self.set_collision_mask_value(2, toggle) #Collide with Players
	self.set_collision_layer_value(4, toggle) #Collide with other bubbles

func float(delta: float) -> Vector2:
	var airCurrent: TileMapLayer = Game.world.level.AirCurrent
	if(airCurrent):
		var localMapPos = airCurrent.to_local( self.global_position)
		var pos = airCurrent.local_to_map(localMapPos )
		var cellData = airCurrent.get_cell_tile_data(pos)
		var dir = Vector2.UP
		if(cellData):
			dir =  cellData.get_custom_data("Direction")
		
		return dir * Vector2(self.float_hor_speed, self.float_vert_speed)
		pass
		
	
	return Vector2.ZERO

func float_xy(delta: float) -> Vector2:
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


func float_x(delta: float) -> Vector2:

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


func hitBoxBodyEntered(areaOwner: Node2D) -> void:
	print(areaOwner)
	#var areaOwner = body.get_parent()
	if(self.state == BubbleState.Popping and  areaOwner is Bubble):
		if(areaOwner.state != BubbleState.Popping and self.poppedBy ):
			areaOwner.poppedBy = self.poppedBy
			areaOwner.playerPop( self.poppedBy)
			
	pass
	
	
func hitBoxAreaEntered(area: Area2D) -> void:
	pass
	
	

func _physics_process(delta: float) -> void:
	if(!self.destination) :
		self.destination = Game.world.level.bubbleDestination
	match self.state: 
		_:
			self.target_velocity = self.float(delta)


	self.hurtbox_update(delta)
	
# Give the Hurtbox a slight Lag, behind our overall position
func hurtbox_update(delta: float) -> void:
	var local_v = self.linear_velocity.rotated( -self.global_rotation )
	var target = (-local_v * 0.2).limit_length(3)   #computes the desired offset. Max 4 pixels in total.
	
	# Smoothly approach target
	var follow_speed = 30.0
	var a := 1.0 - exp(-follow_speed * delta)
	hurtboxOffset = hurtboxOffset.lerp(target, a)
	self.hurtbox.position = hurtboxOffset


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	if(self.lock_force_damp):
		return
	var target_v = self.target_velocity
	var current_v = state.linear_velocity
	var v_damp = 12 
	var force_max = 1200
	
	var v_delta = target_v - current_v 
	
	var force = v_delta  * v_damp * mass
	
	if(force.length() > force_max):
		force = force.normalized() * force_max
		
		
	state.apply_central_force(force)
	pass	

# Player-triggered pop	
func playerPop(player: Player) -> void:
	self.pop()
	self.collisionShape.disabled = true
	if(self.hitbox) :
		self.hitbox.monitoring = true 
		self.hitbox.set_collision_mask_value(4, true)

	var playerStats = Game.getPlayerEntry(player.player_index).stats
	var bubbles_popped = playerStats.getStat(PlayerStats.STATKEY_BUBBLES_POPPED)
	
	playerStats.setStat( PlayerStats.STATKEY_BUBBLES_POPPED, bubbles_popped + 1 )

func setFloating() -> void:
	self.state = BubbleState.Floating
	self.hitbox.call_deferred("set_monitoring", false)
	self.collisionShape.disabled = false
	self.hurtbox.call_deferred("set_monitoring", true)
	self.hurtbox.call_deferred("set_monitorable", true)

	self.toggle_collision(true)
	self.set_collision_mask_value(4, true) # Collide with other bubbles now





func pop() -> void:
	self.state = BubbleState.Popping
	self.toggle_collision(false)
	self.sprite.visible = true
	self.linear_velocity = Vector2.ZERO
	var popAnimation =  self.animationPlayer.get_animation("PON")
	self.get_tree().create_timer( popAnimation.length).timeout.connect( func (): 
		queue_free() 
	)
	
	
	self.animationPlayer.play("PON")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.sprite.rotation = -self.rotation

	$DebugLayer.rotation = -self.rotation
	$DebugLayer.position = Vector2.ZERO
	
	
	self.infoLabel.text = "(%.2f, %.2f)" % [self.linear_velocity.x, self.linear_velocity.y]
	
	
	
