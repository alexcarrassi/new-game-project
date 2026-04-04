class_name Bubble extends RigidBody2D

@export var hor_speed: float = 300.0
@export var float_vert_speed: float = 3.0
@export var float_hor_speed: float = 3.0

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




func get_swirl_velocity(vortex_center: Vector2) -> Vector2:
	
	var radial: Vector2 = global_position - vortex_center
	var dist: float = radial.length() 
	
	if(dist < 0.001) :
		return Vector2.ZERO	
	
	var radial_dir: Vector2 = radial / dist 
	var tangent_dir: Vector2  = Vector2(-radial_dir.y, radial_dir.x )	
	
	var tangential: Vector2 = tangent_dir * 2.0 
	var inward: Vector2 = -radial+dir * 2.0 
	return tangential + inward
		

func get_airCurrent_velocity() -> Vector2: 
	var airCurrent: TileMapLayer = Game.world.level.AirCurrent
	if(airCurrent):
		var localMapPos = airCurrent.to_local( self.global_position)
		var pos = airCurrent.local_to_map(localMapPos )
		var cellData = airCurrent.get_cell_tile_data(pos)
		var current_dir = Vector2.UP
		if(cellData):
			current_dir =  cellData.get_custom_data("Direction")
		
		if(current_dir == Vector2.ZERO):
			# Swirl tile.
			var local_center = airCurrent.map_to_local(pos)
			var global_center = airCurrent.to_global(local_center)
			
			return get_swirl_velocity(global_center)
			#return dir * Vector2(self.float_hor_speed, self.float_vert_speed)

		else:
			dir = current_dir
		return current_dir * Vector2(self.float_hor_speed, self.float_vert_speed)
		pass
		
	
	return Vector2.ZERO
		

func float(delta: float) -> Vector2:
	return get_airCurrent_velocity()


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
	
	if( self.state != BubbleState.Floating):
		return
	var desired_velocity: Vector2 = get_airCurrent_velocity()
	var steered: Vector2 = desired_velocity  # Slowly steer the force by subtracting our current linear vel
	var strength: float = 1
	
	state.apply_central_force(steered * strength)
	
	self.linear_damp = 4.0
	pass	

# Player-triggered pop	
func playerPop(player: Player) -> void:
	self.pop()
	self.collisionShape.disabled = true
	if(self.hitbox) :
		self.hitbox.monitoring = true 
		self.hitbox.set_collision_mask_value(4, true)

	player.statEvent.emit(PlayerStats.STATKEY_BUBBLES_POPPED,1)

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
	
	
	
