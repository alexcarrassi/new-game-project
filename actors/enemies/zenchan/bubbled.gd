class_name enemy_bubbled extends State

enum BubblePhase  {
	FLOAT_Y,
	FLOAT_X
}

var phase : BubblePhase = BubblePhase.FLOAT_Y 

func enter(prev_state_path: String, data: Dictionary = {} ) -> void :
	
	var actor = self.body
	self.main_animation = "NORMAL/BUBBLED"
	
	actor.set_collision_layer_value(7, true)
	actor.set_collision_layer_value(3, false)
	pass
	
func exit() -> void:
	var actor = self.body
	actor.set_collision_layer_value(7, false)
	actor.set_collision_layer_value(3, true)	
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func physics_update(delta: float) -> void:
	var actor = self.body
