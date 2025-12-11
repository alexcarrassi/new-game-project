class_name Enemy extends Actor

@export var players: Array[Player] = []


func onPlayerCollide( player: Player) -> void:
	print("ENEMY")


func flip() -> void:

	self.direction.x *= -1
	self.sprite2D.flip_h = self.direction.x > 0.0
