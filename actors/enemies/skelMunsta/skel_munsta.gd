class_name SkelMunsta extends Enemy

@export var SPEED_INITIAL: float = 100

@export var fx_smokeScene: PackedScene

var huntingSpeed = 100

func _ready() -> void:
	super._ready() 
	sprite2D.visible = false 
	
	var fx_smoke: AnimatedSprite2D =  fx_smokeScene.instantiate()
	fx_smoke.animation_finished.connect( 
		func() -> void: 
			sprite2D.visible  = true
			sm_locomotion.state.finished.emit("HUNT")
			
			fx_smoke.queue_free()	
	)
	
	fx_smoke.global_position = global_position
	Game.world.level.add_child( fx_smoke)
	fx_smoke.play("in")

func _exit_tree() -> void:
	var fx_smoke: AnimatedSprite2D =  fx_smokeScene.instantiate()
	fx_smoke.play('in')
	fx_smoke.global_position = global_position
	Game.world.level.add_child( fx_smoke)
	
	fx_smoke.animation_finished.connect( 
		func() -> void:
			fx_smoke.queue_free()
	)
	
func flip() -> void:

	self.direction.x *= -1
	self.sprite2D.flip_h = self.direction.x > 0.0
