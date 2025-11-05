class_name enemy_bubbled extends State

enum BubblePhase  {
	FLOAT_Y,
	FLOAT_X
}

var phase : BubblePhase = BubblePhase.FLOAT_Y 

func enter(prev_state_path: String, data: Dictionary = {} ) -> void :
	
	self.main_animation = "NORMAL/BUBBLED"
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func physics_update(delta: float) -> void:
	var actor = self.body

	#match self.phase:
		#BubblePhase.FLOAT_Y:
			#actor.velocity = Vector2(0, -1 * actor.FLOAT_SPEED)
			#if(actor.position.y <= actor.Bubble_Destination.position.y):
				#self.phase = BubblePhase.FLOAT_X
				#
		#BubblePhase.FLOAT_X:
			#var distance = (actor.Bubble_Destination.position - actor.position)
			#var velocity = distance * Vector2(actor.FLOAT_SPEED, actor.FLOAT_SPEED)
			#velocity.x = clamp(velocity.x, -actor.FLOAT_SPEED, actor.FLOAT_SPEED)
			#velocity.y = clamp(velocity.y, -actor.FLOAT_SPEED, actor.FLOAT_SPEED)
			#
			#actor.velocity = velocity
#
	#actor.move_and_slide()	
