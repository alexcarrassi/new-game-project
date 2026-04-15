class_name ActorPresentation extends Presentation

var actor: Actor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialize( _subject: Node ) -> void:
	actor = _subject as Actor
	super.initialize(_subject)
	
func setup_signals() -> void:
	actor.actorHurtStart.connect(onActorHurt)	
	actor.actorDeathStart.connect(onActorDeath)

func onActorHurt() -> void:
	SFX.play_sound(&"status", &"hurt")
	
func onActorDeath() -> void:
	SFX.play_sound(&"status", &"death")	
	
