class_name Alive extends State

func enter(prev_state_path: String, data: Dictionary = {}) -> void:
	var actor = self.body

	actor.collisionShape.disabled = false
	actor.loco_locked = false
	actor.act_locked = false
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
