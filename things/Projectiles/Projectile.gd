class_name Projectile extends CharacterBody2D
 
@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var sfx_emission: AudioStream

func dissolve() -> void:
	queue_free()

func _ready() -> void:
	if audioPlayer and sfx_emission:
	
		audioPlayer.stream = sfx_emission
		audioPlayer.play( )   
