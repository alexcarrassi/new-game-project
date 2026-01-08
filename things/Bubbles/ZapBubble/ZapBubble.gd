class_name ZapBubble extends Bubble

@export var zapSpeed = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	self.setFloating()
	self.contact_monitor = true
	self.hitbox.body_entered.connect( self.onHitboxBodyEntered)
	

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func onHitboxBodyEntered(body: Node2D) -> void:
	print("body")
	print(body.name)
	self.queue_free()
	
	
func _physics_process(delta: float) -> void:
	
	match self.state:	
		BubbleState.Popping:
			await get_tree().create_timer(0.5).timeout
			self.state = BubbleState.Shooting
			
		BubbleState.Shooting:
			self.hitbox.set_collision_mask_value(11, true)
			self.hitbox.set_collision_mask_value(9, true)
			self.collisionShape.disabled = true
			self.target_velocity.y = 0
			self.target_velocity.x = self.zapSpeed * dir.x
			
		_:
			if(self.destination != null):
				if(self.position.y > self.destination.position.y):
					self.target_velocity = self.float_y(delta)	
				else:
					self.target_velocity = self.float_x(delta) 	
			
	self.hurtbox_update(delta)
	
	
	
func hitBoxAreaEntered(area: Area2D) -> void:
	print(area.name)	
	var areaOwner = area.get_parent()

	if(areaOwner is Enemy):
		var enemy = areaOwner
		enemy.sm_locomotion.state.finished.emit("FALLING")
		enemy.sm_status.state.finished.emit("DEAD", {"dir": self.dir.x})

	
	

	

func playerPop(player: Player) -> void:
	self.state = BubbleState.Popping
	self.target_velocity = Vector2.ZERO   
	self.linear_velocity = Vector2.ZERO # Override velocity. Stops movement without any kind of damping
	self.toggle_collision(false)
	self.hitbox.call_deferred("set_monitoring", true)
	self.hurtbox.call_deferred("set_monitoring", false)
	self.animationPlayer.play("ZAP")

	self.dir.x = 1 if player.sprite2D.flip_h else -1 
