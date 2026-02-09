class_name FireBubble extends Bubble

@export var projectile: PackedScene 

func _ready() -> void:
	super._ready() 
	super.setFloating()
	
#We skip the popping state, and go straight into the Bubble's Shoot state
func playerPop(player: Player) -> void:
	self.state = BubbleState.Shooting
	self.toggle_collision(false)

	self.dir.x = -1 if player.sprite2D.flip_h else 1  #Direction opposite that of the player
	self.lock_force_damp = true
	self.target_velocity = Vector2.ZERO
	self.linear_velocity = Vector2.ZERO
	
	var projectile: FireProjectile = self.projectile.instantiate()
	self.get_parent().add_child(projectile)
	projectile.position = self.position
	self.queue_free()
	pass
	



func _physics_process(delta: float) -> void:
	match self.state:
		BubbleState.Floating:
			self.target_velocity = self.float(delta)			
			
			self.hurtbox_update(delta)
