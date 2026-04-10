class_name PlayerEntry extends Resource

var stats: PlayerStats 
var player: Player 
var inventory: InventoryController
var id: int

func serialize() -> Dictionary:
	var data = {
		"&stats" = {},
		"$player" = {},
		"$inv"	= {}
	}
	
	
	data["stats"] = stats.serialize()
	data["inv"] = inventory.serialize()
	data["player"] = player.serialize()
	
	return data 
