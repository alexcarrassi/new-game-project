class_name WaterBubble extends Bubble

@export var projectile: PackedScene 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.setFloating()

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
	
	var projectile: WaterProjectile = self.projectile.instantiate()
	self.get_parent().add_child(projectile)
	projectile.position = self.position
	self.queue_free()
	
		
	var stats = Game.getPlayerEntry(player.player_index).stats
	var popped = stats.getStat(PlayerStats.STATKEY_WATERBUBBLES_POPPED)
	stats.setStat(PlayerStats.STATKEY_WATERBUBBLES_POPPED, popped + 1)
	pass
	



func _physics_process(delta: float) -> void:
	match self.state:
		BubbleState.Floating:
			if(self.position.y > self.destination.position.y):
				self.target_velocity = self.float_y(delta)	
			else:
				self.target_velocity = self.float_x(delta) 	
			
			
			self.hurtbox_update(delta)
