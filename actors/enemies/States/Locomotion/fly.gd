class_name Fly extends State

func _ready() -> void:
	self.main_animation = "RUN"


func enter(prev_state: State, transition_data: Dictionary) -> void:
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

		if( abs(collision_normal.x) > 0.3):
			actor.direction.x =  1 if collision_normal.x > 0 else -1
		if(abs(collision_normal.y) > 0.3 ) :
			actor.direction.y =	  1 if collision_normal.y > 0 else -1
	
	actor.sprite2D.flip_h = actor.direction.x > 0.0
	actor.velocity = Vector2(actor.MAX_RUN_VELOCITY, actor.MAX_RISE_VELOCITY) * actor.direction
	pass
	
