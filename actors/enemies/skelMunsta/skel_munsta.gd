class_name SkelMunsta extends Enemy

@export var SPEED_INITIAL: float = 100
var huntingSpeed = 100

func flip() -> void:

	self.direction.x *= -1
	self.sprite2D.flip_h = self.direction.x > 0.0
