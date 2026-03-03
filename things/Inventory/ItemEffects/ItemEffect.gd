class_name ItemEffect extends Resource
var ctx: ItemUseContext

func apply(ctx: ItemUseContext) -> void:
	self.ctx = ctx
	pass
