class_name WaterBubble extends Bubble

@export var tideSpeed: float = 150
@onready var tidePath: Path2D = $Path2D
@onready var tidePathFollow: PathFollow2D = $Path2D/PathFollow2D

@onready var groundCast: ShapeCast2D = $Sensors/GroundCast
@onready var frontCast: RayCast2D = $Sensors/FrontCast

var sprite_flicker_hz = 45.0
var isGrounded: bool = false

var _flicker_accum: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.setFloating()
	self.tidePathFollow.visible = false

	
	#self.tidePath.set_as_top_level(true)
	self.body_entered.connect( func(body: Node) -> void:
		print(body.name)	
	)
	
	self.tidePath.curve = Curve2D.new()
	pass # Replace with function body.
	

#We skip the popping state, and go straight into the Bubble's Shoot state
func playerPop(player: Player) -> void:
	self.state = BubbleState.Shooting
	self.toggle_collision(false)

	self.dir.x = -1 if player.sprite2D.flip_h else 1  #Direction opposite that of the player
	self.lock_force_damp = true
	self.animationPlayer.play("TIDE")
	self.target_velocity = Vector2.ZERO
	self.linear_velocity = Vector2.ZERO
	#self.tidePath.reparent(Game.world.level)
	self.tidePath.curve.add_point(self.position)

	self.set_collision_layer_value(1, false)
	
	pass
	
func tryAddPathPoint(point: Vector2) -> void:
	var pointCount = self.tidePath.curve.point_count
	self.tidePath.curve.add_point(point, Vector2.ZERO, Vector2.ZERO, clamp(pointCount - 2, 0, pointCount - 1) )	
	
func setPathHead(point: Vector2) -> void:
	var point_count = self.tidePath.curve.point_count
	self.tidePath.curve.add_point( point )
		



func _physics_process(delta: float) -> void:
	match self.state:
		BubbleState.Floating:
			if(self.position.y > self.destination.position.y):
				self.target_velocity = self.float_y(delta)	
			else:
				self.target_velocity = self.float_x(delta) 	
			
			
			self.hurtbox_update(delta)
	
		BubbleState.Shooting:
			
			
			# if grounded, horizontal
			# not grounded, fall down	
			if(self.isGrounded):
				self.target_velocity = Vector2(self.tideSpeed * self.dir.x, self.get_gravity().y * delta)
			else:
				self.target_velocity =  Vector2(0, self.tideSpeed)
				
			self.linear_velocity = self.target_velocity	
				
			self.setPathHead( self.position )


			#If we're switching states, we need to record that position for the sprite's oscillation	
			if(self.groundCast.is_colliding() != self.isGrounded):
				self.tryAddPathPoint( self.position)
			
			# We were airborne just now, but landing
			if(!self.isGrounded && self.groundCast.is_colliding()):
				self.dir.x *= -1
				self.frontCast.target_position.x *= -1
				
			# We were grounded and have just hit a wall	
			#if(self.isGrounded && self.frontCast.is_colliding()):
				#self.queue_free()

			self.isGrounded = self.groundCast.is_colliding()			
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#self.tidePathFollow.progress += self.tideSpeed * 3 * delta
	if(self.state == BubbleState.Shooting):
		
		self._flicker_accum += delta
		if(self._flicker_accum >= 1/self.sprite_flicker_hz) :
			self._flicker_accum = 0
			self.tidePathFollow.visible = !self.tidePathFollow.visible 
			self.sprite.visible = !self.tidePathFollow.visible
			
		
		var curve_length = self.tidePath.curve.get_baked_length()
		if(curve_length < 32):
			self.tidePathFollow.progress = 0
		
		else:

			#var progress_ofsset = clamp(curve_length - 32, 0, curve_length  -32)
			self.tidePathFollow.progress +=  self.tideSpeed*delta
			
		if( curve_length > 0 && self.tidePathFollow.progress == curve_length ) :
			self.queue_free()
