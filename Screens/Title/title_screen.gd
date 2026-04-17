class_name TitleScreen extends Control

@export var bg_starScene: PackedScene
@export var starCount: float = 20
@onready var animationPlayer = $AnimationPlayer
@onready var starsLayer = $StarsLayer
@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer

var rng := RandomNumberGenerator.new()
var stars: Array[bg_Star] = []

signal logo_at_full_opacity


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audioPlayer.play()
	animationPlayer.play("Splash Intro")
	await get_tree().process_frame

	var area_size = starsLayer.size
	#SPawning 20 bg stars at random positions on the screen
	for i in starCount:
		var star: bg_Star = bg_starScene.instantiate() 
		starsLayer.add_child(star)
		star.position = Vector2(
			rng.randf_range(0, area_size.x),
			rng.randf_range(0, area_size.y)
		)
		
		stars.append( star) 
		
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_accept")):
		Game.exit_to_main_menu()

func shoot_stars() -> void: 
	for i in stars.size():

		if i % 2 == 0:
			
			var star: bg_Star = stars[i] 	
			var rng_number = rng.randf_range(0.0, 1.0)
			star.dir.x = -0.5 if rng_number < 0.5 else 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
