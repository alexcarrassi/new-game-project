class_name EmitOrb extends ItemEffect

var orbScene = preload("res://things/Projectiles/OrbProjectile.tscn")

func apply( ctx: ItemActionContext ) -> void:
	print("Emitting orb")
	
	var orb = orbScene.instantiate()
	orb.position = ctx.usedAtPosition
	ctx.itemPickup.get_parent().add_child(orb)
	
	pass

	
	
