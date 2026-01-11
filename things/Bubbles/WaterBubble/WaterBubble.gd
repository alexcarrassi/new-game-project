class_name WaterBubble extends Bubble

@export var tideSpeed: float = 150
var tidePositions: Array[Vector2] = []
var spriteSpeed = 175

var isGrounded: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.setFloating()
	self.contact_monitor = true
	self.max_contacts_reported = 9
	
	self.body_entered.connect( func(body: Node) -> void:
		print(body.name)	
	)
	
	pass # Replace with function body.
	

#We skip the popping state, and go straight into the Bubble's Shoot state
func playerPop(player: Player) -> void:
	self.state = BubbleState.Shooting
	self.toggle_collision(false)

	self.dir.x = -1 if player.sprite2D.flip_h else 1  #Direction opposite that of the player
	self.tidePositions = [self.position]
	self.lock_force_damp = true
	self.animationPlayer.play("TIDE")
	self.target_velocity = Vector2.ZERO
	self.linear_velocity = Vector2.ZERO
	self.set_collision_layer_value(1, false)
	
	pass


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	super._integrate_forces(state)
		
	#print(state.get_contact_count())

	var grounded = false 
	var contact_count = state.get_contact_count() 
	for i: int in range(contact_count):
		var collider = state.get_contact_collider_object(i)
		var normal = state.get_contact_local_normal(i)
		
		if(collider is TileMapLayer):
			if(normal.dot(Vector2.UP) > 0.7):
				grounded = true
				if(!self.isGrounded):
					#If we werent grounded yet, we must switch direction.
					self.dir.x *= -1
			else:
				if(self.isGrounded):
					#If collided with a non-ground Tile, and we already are Grounded, we dissolve
					self.queue_free()
			
				
	#If we're switching states, we need to record that position for the sprite's oscillation	
	if(grounded != self.isGrounded):
		self.tidePositions.append( self.position )
	self.isGrounded = grounded

func _physics_process(delta: float) -> void:
	match self.state:
		BubbleState.Floating:
			if(self.position.y > self.destination.position.y):
				self.target_velocity = self.float_y(delta)	
			else:
				self.target_velocity = self.float_x(delta) 	
				
		BubbleState.Shooting:
			# if grounded, horizontal
			# not grounded, fall down	
			self.linear_velocity = 	Vector2(self.tideSpeed * self.dir.x, 0) if self.isGrounded else Vector2(0, self.tideSpeed)
				
				
	self.hurtbox_update(delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
