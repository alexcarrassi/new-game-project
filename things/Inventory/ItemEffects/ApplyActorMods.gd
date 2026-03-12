# Apply a given array of Mods to the immediate actor that initiated the ItemAction
class_name ApplyActorMods extends ItemEffect

@export var mods: Array[ActorMod] = []

func apply( ctx: ItemActionContext ) -> void:
	
	var player = ctx.actor as Player
	for mod: ActorMod in mods:
		player.modController.addMod(mod)
