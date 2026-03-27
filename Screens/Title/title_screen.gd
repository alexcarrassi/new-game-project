class_name TitleScreen extends Control

@export var bg_starScene: PackedScene
@onready var animationPlayer = $AnimationPlayer
@onready var starsLayer = $StarsLayer

var rng := RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationPlayer.play("Splash Intro")
	await get_tree().process_frame

	var area_size = starsLayer.size
	#SPawning 20 bg stars at random positions on the screen
	for i in 20:
		var star: bg_Star = bg_starScene.instantiate() 
		starsLayer.add_child(star)
		star.position = Vector2(
			rng.randf_range(0, area_size.x),
			rng.randf_range(0, area_size.y)
		)
		star.play("shine")
		
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
