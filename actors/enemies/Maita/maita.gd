class_name Maita extends Enemy

@export var fireBallScene: PackedScene
var fireBall : Fireball
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	super._ready()

func think() -> void:
	super.think()
	
	var random_number = rng.randf()
	
	if( random_number < 1 && !self.has_owned(&"Fireball")):
		if( self.player_above() == 0 && self.isFacing( self.get_targetPlayer())):
			self.intent.act = &"Throw_Fireball"
			
