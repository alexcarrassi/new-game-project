class_name Alive extends State

func enter(prev_state: State, data: Dictionary = {}) -> void:
	var actor = self.body

	actor.collisionShape.disabled = false
	actor.sm_locomotion.physics_process_paused = false
	actor.sm_act.physics_process_paused = false

	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
