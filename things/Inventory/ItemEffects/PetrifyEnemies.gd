class_name PetrifyEnemies extends ItemEffect


func apply( ctx: ItemActionContext ) -> void:

	var petrificationMod: Petrify = Petrify.new() 
	var enemies: Array[Node] = Game.get_tree().get_nodes_in_group("Enemies")
	for enemyNode : Enemy in enemies:
		if(enemyNode.sm_status.state.name == "ALIVE" && enemyNode.sm_locomotion.state.name != "BUBBLED"):
			enemyNode.modController.addMod( petrificationMod )
#
#func end(ctx: ItemActionContext) -> void:
	#var enemies: Array[Node] = Game.get_tree().get_nodes_in_group("Enemies")
	#for enemyNode : Enemy in enemies:
		#enemyNode.modController.removeMod( mod )
#
	#
	#
