class_name Maita extends Enemy

@export var fireBallScene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


func think() -> bool:
	if( !super.think() ) :
		return false
		
	var random_number = rng.randf()
	if( random_number < 0.9):
		if( self.player_above() == 0) :
			self.intent.act = &"Throw_Fireball"
			
			
	
	print(self.intent.act)
	print(self.intent.locomotion)		
	
	return true
			
