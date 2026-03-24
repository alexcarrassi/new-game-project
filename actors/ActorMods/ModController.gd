class_name ModController extends Resource

var actor: Actor
var mods_ : Array[ActorMod] = []
	
var mods : Dictionary[StringName, ModEntry]
	
	
func addMod( mod: ActorMod) -> void:
	if(self.mods.has( mod.mod_id)):
		if( mod.stackable) :
			self.mods[mod.mod_id].stack += 1
		pass
		
	else :	
		var newEntry = ModEntry.new()
		newEntry.mod = mod
		newEntry.is_active = false
		newEntry.timeLeft = mod.timeActive
		newEntry.mod.activate( self.actor )
		self.mods[mod.mod_id] = newEntry
		

# Clears all mods on an actor. Used in situations like Death.
# Forcefull removal does not deactivate the mod, instead it deletes it outright.
func clear_all(force: bool = false) -> void:
	if(force) :
		mods = {}
		return
		
		
	for modKey: StringName in mods:
		var modEntry: ModEntry = mods.get(modKey)
		removeMod( modEntry.mod, true)



func removeMod( mod: ActorMod, remove_full: bool = false) -> void:
	if(self.mods.has(mod.mod_id)) :
		
		if( remove_full) :
			self.mods.erase(mod.mod_id)
			mod.deactivate(self.actor)
		else:
			self.mods[mod.mod_id].stack -= 1
			if(self.mods[mod.mod_id].stack < 1):
				self.mods.erase(mod.mod_id)
				mod.deactivate(self.actor)
				
func tick( delta: float) -> void:
	for mod_id in self.mods.keys():
		var modEntry = self.mods[mod_id]
		var mod = modEntry.mod
		
		mod.tick_physics(delta, self.actor)
		modEntry.timeLeft -= delta
		
		if(modEntry.timeLeft <= 0 && mod.timeActive > 0) :
			self.removeMod(mod)
		
		
func tick_process( delta: float) -> void:
	for mod_id in self.mods.keys():
		var modEntry = self.mods[mod_id]
		var mod = modEntry.mod	
		
		mod.tick_process(delta, actor)

# Handles:
#	Adding  		(entering)
#	Removing		(exiting)
#	Ticking the Mods
#	Checking for expiration
# 	Emitting Mod signals
