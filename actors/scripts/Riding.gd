class_name Riding extends State


#State for riding a bubble
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func enter(previous_state_path: String, data: Dictionary) -> void:
	self.body.act_locked = true 
	self.body.velocity = Vector2.ZERO
	self.body.hurtbox.monitorable = false 
	self.body.hurtbox.monitoring = false

	var owner = data.get("owner", null)
	if(owner) :
		self.body.reparent(owner)
		
	self.body.position.x = 0
	self.body.position.y = 8
		

	#self.body.collisionShape.disabled = true

func physics_update(delta: float) -> void:
	var actor = self.body as Player 
	
	if(actor.buffer_times["jump"] > 0.0):
		self.finished.emit("JUMPING")

func exit() -> void:
	var projectileParent = self.body.get_parent() 
	self.body.hurtbox.monitorable = true 
	self.body.hurtbox.monitoring = true 
	self.body.act_locked = false 
	
	self.body.reparent(Game.world.level)
	#self.body.collisionShape.disabled = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
