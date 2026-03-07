class_name BigFalling extends ItemPickup

@export var fallingSpeed: float = 100.0

func _physics_process(delta: float) -> void:
	position.y += delta * fallingSpeed
	
	if(position.y >= 300) :
		queue_free()
