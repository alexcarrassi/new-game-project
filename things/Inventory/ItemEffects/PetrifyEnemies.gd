class_name PetrifyEnemies extends Powerup


func start( ctx: ItemActionContext ) -> void:


	print("petrify everyone")

	var petrificationMod: Petrify = Petrify.new() 
	petrificationMod.timeActive = powerup_time
	mod = petrificationMod
	
	var enemies: Array[Node] = Game.get_tree().get_nodes_in_group("Enemies")
	for enemyNode : Enemy in enemies:
		enemyNode.modController.addMod( mod )

	
	
func end(ctx: ItemActionContext) -> void:
	var enemies: Array[Node] = Game.get_tree().get_nodes_in_group("Enemies")
	for enemyNode : Enemy in enemies:
		enemyNode.modController.removeMod( mod )

	
	
