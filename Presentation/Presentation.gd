class_name Presentation extends Node

@onready var SFX: AudioBank = $SFX

var subject: Node

func _ready() -> void:
	pass
	
# Setup and initialize
func initialize( _subject: Node ) -> void:
	subject = _subject
	setup_signals()
	
# Setup your signals 	
func setup_signals() -> void:
	pass	 
		
	
	
