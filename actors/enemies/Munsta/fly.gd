class_name Fly extends State

func _ready() -> void:
	self.main_animation = "FLY"


func enter(prev_state_path: String, transition_data: Dictionary) -> void:
	var actor = self.body 
	actor.velocity = Vector2(actor.MAX_RUN_VELOCITY, actor.MAX_RUN_VELOCITY) * actor.direction



# Munsta's Flying state is very simple:
# He will always fly diagonally. Starting off going downward, towards his current direction
# When colliding with a Tile Horizontally: his speed.x is reversed
# When colliding with a Tile Vertically:   his speed.y is reversed
func physics_update(delta: float) -> void:
	
	var actor = self.body 
	actor.move_and_slide()
	
	for i in actor.get_slide_collision_count():
		var collision = actor.get_slide_collision(i)
		var collision_normal = collision.get_normal()
		
		# Bouncing is pretty much copying the collision normal's direction.
		if(abs(collision_normal.x ) > 0.0) :
			actor.direction.x = collision_normal.x
		if( abs(collision_normal.y) > 0.0) :
			actor.direction.y = collision_normal.y	
	
	actor.velocity = Vector2(actor.MAX_RUN_VELOCITY, actor.MAX_RUN_VELOCITY) * actor.direction

	
