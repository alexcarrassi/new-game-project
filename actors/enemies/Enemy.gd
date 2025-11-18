class_name Enemy extends Actor

@export var players: Array[Player] = []


func onPlayerCollide( player: Player) -> void:
	print("ENEMY")
