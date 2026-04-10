class_name Give_KillingAura extends ActorMod

var aura: Area2D 

func _init() -> void:
	self.timeActive = 6
	self.mod_id = &"Aura"

func activate(actor: Actor) -> void:
	print("Start Aura")
	#Programmatically create an Area2D, that will function as a Hitbox, killing enemies that come into contact
	
	var aura = Area2D.new() 
	var auraShape = actor.collisionShape.duplicate()
	var shapeRect = auraShape.shape.get_rect()
	shapeRect.size = Vector2(16,16)
	auraShape.position = Vector2(0 , -shapeRect.size.y/2 )
	#auraShape.scale = Vector2(2,2)
	
	aura.add_child(auraShape) 
	actor.add_child( aura )
	aura.modulate = Color.WEB_PURPLE
	aura.self_modulate = Color.BROWN
	aura.monitoring = true
	aura.monitorable = true

	aura.set_collision_mask_value(9, true)
	self.aura = aura
	aura.area_entered.connect( func(area: Area2D ) -> void:
		var areaOwner = area.get_parent()
		if(areaOwner is Enemy) :
			areaOwner.sm_status.state.finished.emit("DEAD")
		pass	
	)
	#

	
	
	
	
	

func deactivate(actor: Actor) -> void:
	print("End Aura")
	aura.queue_free()
	
	
func tick_physics(delta: float, actor: Actor) -> void:
	pass
	
	
func tick_process(delta: float, actor: Actor) -> void:
	pass
	
