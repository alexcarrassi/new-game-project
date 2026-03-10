class_name ItemEffect extends Resource
var ctx: ItemActionContext

func apply(ctx: ItemActionContext) -> void:
	self.ctx = ctx
	pass

func clear(ctx: ItemActionContext) -> void:
	pass 
