class_name Dead extends State

var jump_velocity = Vector2(130.0, -300.0)
var max_fall_velocity: float = 100.0
var timer: Timer
var collision_disable_ms: float = 1.5

# Model a Jumping arc. Collides with Outer Walls of the level.
# When reaching Max fall velocity: fall down vertically (no x velocity), collide with inner geometry. 
# When reaching ground, Despawn.

func enter(prev_state_path: String, data: Dictionary = {}) -> void:
	print("ENTER DEAD")
	self.main_animation = "DEAD"

	var actor = self.body 
	actor.loco_locked = true
	actor.act_locked = true 
	
	#starting velocity: following a jump arc
	actor.velocity = self.jump_velocity
	actor.velocity.x *= actor.direction.x

	#disable collision with inner tiles.
	actor.set_collision_mask_value(8, false)
	
	#After some time, re enable the collision again
	if(self.timer == null) :
			
		self.timer = Timer.new()
		self.timer.one_shot = true
		self.timer.wait_time = collision_disable_ms
		self.timer.timeout.connect( self.reEnableCollision )
		self.add_child( timer )
		self.timer.start()
		
func reEnableCollision() -> void:
	var actor = self.body
	print("RECOLLIDE")
	actor.set_collision_mask_value(8, true)
	
func physics_update(delta: float) -> void:
	var actor = self.body
	actor.velocity.y += actor.get_gravity().y * 0.4 * delta
	actor.velocity.y = clamp(actor.velocity.y, self.jump_velocity.y, self.max_fall_velocity)
	
	
	if(actor.velocity.y >= self.max_fall_velocity ):
		actor.velocity.x = 0
	else :
		actor.velocity.x = self.jump_velocity.x

	actor.velocity.x *= actor.direction.x


	
	actor.move_and_slide()

	if( actor.wall_ahead() ):
		actor.flip()
		
	if(actor.is_on_floor()):
		actor.queue_free()
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
