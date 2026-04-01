class_name WorldUI extends CanvasLayer

@onready var Hurry: TextureRect = $"Root/Hurry!"
@onready var root: Control = $Root

signal hurryShown()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func showHurry() -> Tween:
	
	#Creating a tween animation
	#Target
	var screen_size: Vector2 = root.size
	var target_pos: Vector2 = Vector2(
		screen_size.x * 0.5 - Hurry.size.x * 0.5, 
		screen_size.y * 0.5 - Hurry.size.y * 0.5
	)
	
	
	#dest 
	var start_pos: Vector2 = Vector2(
		target_pos.x,
		screen_size.y + Hurry.size.y
	)
	
	
	#initialize
	self.Hurry.position = start_pos
	self.Hurry.visible = true 
	
	#tween
	var tween: Tween = create_tween()
	tween.tween_property(Hurry, "position", target_pos, 1)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_interval(1.0)
	
	tween.finished.connect( func() -> void: 
		self.Hurry.visible =  false
	)
	
	return tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
