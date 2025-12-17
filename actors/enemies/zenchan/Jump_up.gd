class_name zenchan_JumpUp extends State

var target_y: float = 0.0

func enter(prev_state_path: String, data: Dictionary = {} ) -> void:
	var actor = self.body as Enemy
	actor.velocity.x = 0
	actor.velocity.y = 0
	
	await get_tree().create_timer(0.2).timeout
	actor.flip()
	await get_tree().create_timer(0.2).timeout
	actor.flip()
	await get_tree().create_timer(0.2).timeout

	
	self.target_y = actor.get_floor_above_y()
	
	var tween = create_tween()
	tween.tween_property(actor, "position", Vector2(actor.position.x, self.target_y), 0.7)
	
	tween.finished.connect( func() -> void: self.finished.emit("FALLING"))
	#tween.finished.connect( self.exit)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.main_animation = "RUN"
	pass # Replace with function body.


func physics_update(delta: float) -> void:
	var actor = self.body
	actor.move_and_slide()

	pass
	#
	#await get_tree().create_timer(1).timeout
	#actor.velocity.y = -50
	#self.finished.emit("FALLING")

	
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
