class_name bg_Star extends AnimatedSprite2D

var movement_speed: Vector2 = Vector2(35, 20)
var dir: Vector2 = Vector2.UP 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("shine")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += movement_speed * dir * delta
	var parent_size = get_parent().size
	
	position.x = wrapf(position.x, 0.0, parent_size.x) 
	position.y = wrapf(position.y, 0.0, parent_size.y)
	pass
