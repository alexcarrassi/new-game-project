class_name SkelMunsta extends Enemy

@export var SPEED_INITIAL: float = 100
var huntingSpeed = 100

	
	
func onPlayerCollide( player: Player) -> void:
	player.sm_status.state.finished.emit("HURT")	
