class_name ZapBubble extends Bubble

@export var scene_LightningProjectile: PackedScene
@export var zapSpeed: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	self.setFloating()
	self.contact_monitor = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func onHitboxBodyEntered(body: Node2D) -> void:
	self.queue_free()
	
	
func _physics_process(delta: float) -> void:
	
	match self.state:	
		BubbleState.Popping:
			await get_tree().create_timer(0.5).timeout
			self.state = BubbleState.Shooting
		_:
			self.target_velocity = self.float(delta)
	self.hurtbox_update(delta)
	


func playerPop(player: Player) -> void:
	
	# instantiate lightningprojectile

	if( scene_LightningProjectile):
		
		var projectile: LightningProjectile = scene_LightningProjectile.instantiate() as LightningProjectile
		get_parent().add_child(projectile)
		projectile.position = position

		var player_direction = Vector2.RIGHT if player.sprite2D.flip_h == false else Vector2.LEFT

		projectile.direction = player_direction * Vector2(-1, 0)
		
		
	
	self.queue_free()
	player.statEvent.emit(PlayerStats.STATKEY_THUNDERBUBBLES_POPPED, 1)
