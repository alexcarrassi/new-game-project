class_name PickupEffect_Score extends PickupEffect

@export var score: int = 100
@export var texture: Texture2D



func apply( actor: Actor) -> void:
	#var newPopup = popup.instantiate() as Sprite2D 
	if( actor is Player) :
		
		var newPopup = PickupPopup.new()
		newPopup.texture = self.texture 
		newPopup.position = actor.position
		newPopup.position.y -= 8 
		actor.get_tree().root.add_child(newPopup)
		actor.score += self.score
		actor.scoreUpdated.emit(  )
		
		
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
		


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
