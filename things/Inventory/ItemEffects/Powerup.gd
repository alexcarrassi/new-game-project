#For now, we always assume a Powerup contains an ItemActionContext and a Mod
class_name Powerup extends ItemEffect
var mod: ActorMod

@export var powerup_time: float = 5.0

func apply(ctx: ItemActionContext) -> void:
	
	start(ctx)
	Game.get_tree().create_timer(powerup_time).timeout.connect(
		func() -> void:
			end(ctx) 
	)
	
	
func start(ctx: ItemActionContext) -> void:
	pass
	
	
func end(ctx: ItemActionContext) -> void:
	pass	
