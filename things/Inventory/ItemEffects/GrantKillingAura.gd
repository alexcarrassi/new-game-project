class_name GrantKillingAura extends Powerup

func start(ctx: ItemActionContext) -> void:
	var actor = ctx.actor 
	var mod: ActorMod = KillingAura.new()
	mod.timeActive = self.powerup_time
	actor.modController.addMod( mod )
	self.mod = mod


func end(ctx: ItemActionContext) -> void:
	var actor = ctx.actor 
	actor.modController.removeMod( mod )
