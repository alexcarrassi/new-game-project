class_name ZapBubble extends Bubble

@export var zapSpeed = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	self.setFloating()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	
	match self.state:	
		BubbleState.Popping:
			await get_tree().create_timer(0.5).timeout
			self.state = BubbleState.Shooting
			
		BubbleState.Shooting:
			self.target_velocity.y = 0
			self.target_velocity.x = self.zapSpeed * dir.x
			
		_:
			if(self.destination != null):
				if(self.position.y > self.destination.position.y):
					self.target_velocity = self.float_y(delta)	
				else:
					self.target_velocity = self.float_x(delta) 	
			
	self.hurtbox_update(delta)

		

func playerPop(player: Player) -> void:
	self.state = BubbleState.Popping
	self.target_velocity = Vector2.ZERO
	self.linear_velocity = Vector2.ZERO
	self.toggle_collision(false)
	self.hitbox.call_deferred("set_monitoring", true)
	self.animationPlayer.play("ZAP")
	
	self.dir.x = 1 if player.sprite2D.flip_h else -1 
