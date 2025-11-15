class_name PickupPopup extends Sprite2D

var showTime: float = 0.50
var ySpeed: float = 50
var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	self.position.y -= self.ySpeed * delta

	self.time += delta
	if(self.time >= showTime) :
		queue_free()
		pass
