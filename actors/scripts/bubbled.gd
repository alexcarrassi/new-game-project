class_name Bubbled extends State


func enter(prev_state_path: String, data: Dictionary = {} ) -> void :
	
	print("BUBBLED")
	var actor = self.body
	self.main_animation = "BUBBLED"
	
	actor.loco_locked = true
	actor.act_locked = true 
	
	actor.collisionShape.disabled = true
	#actor.set_collision_layer_value(7, true)
	#actor.set_collision_layer_value(3, false)
	
	pass
	
func exit() -> void:
	print("UNBUBBLED")
	var actor = self.body
	actor.collisionShape.disabled = false
	#actor.set_collision_layer_value(7, false)
	#actor.set_collision_layer_value(3, true)	
	actor.loco_locked = false
	actor.act_locked = false 
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func physics_update(delta: float) -> void:
	var actor = self.body
