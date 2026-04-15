class_name PlayerPresentation extends ActorPresentation 

var player: Player


func initialize( _subject: Node ) -> void:
	player = _subject as Player
	super.initialize(_subject)
	
func setup_signals() -> void:
	player.has_jumped.connect(onJump)
	player.has_shot_bubble.connect(onShotBubble)
	super.setup_signals()
	
func onJump() -> void:
	SFX.play_sound(&"Locomotion", &"jump")
	
func onShotBubble() -> void:
	SFX.play_sound(&"Locomotion", &"bubbleshot")
		
