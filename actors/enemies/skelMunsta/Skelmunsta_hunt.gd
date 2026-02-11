class_name SkelMunsta_Hunt extends State

func enter(prev_state_path: String, data: Dictionary) -> void:
	self.main_animation = "move"
	
	var actor = self.body as SkelMunsta
	
	#find the player's position, and set that as our target.
	var targetPos: Vector2 = Vector2.ZERO
	
	if(Game.playerEntries.is_empty()) :
		pass
	
	var targetPlayer = null
					
	if(Game.playerEntries.has( 0 )):
		targetPlayer = Game.playerEntries[0].player
		
	if(targetPlayer == null):
		self.finished.emit("IDLE")
		
	targetPos = Game.playerEntries[0].player.position		
			
	#Determine duration necessary for travel
	var dist: float = actor.position.distance_to( targetPos)	
	var time = dist / actor.huntingSpeed
	
	#flip the sprite (then facing right) if the distance is > 0.
	actor.sprite2D.flip_h = targetPos.x  > actor.position.x
		
	var huntTween = create_tween().tween_property(actor, "position", targetPos, time )
	huntTween.finished.connect( func() -> void:
		self.finished.emit("IDLE")	
	)
