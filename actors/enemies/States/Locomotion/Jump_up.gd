class_name zenchan_JumpUp extends State

var target_y: float = 0.0
var is_jumping: bool = false
var windups:int = 0
var windup_timer: float = 0
var jump_speed: float = 50.0
var tween: Tween


func enter(prev_state: State, data: Dictionary = {} ) -> void:
	var actor = self.body as Enemy
	actor.velocity.x = 0
	actor.velocity.y = 0
	windups = 0 
	windup_timer = 0.2
	is_jumping = false
	#
	#await get_tree().create_timer(0.2).timeout
	#actor.flip()
	#await get_tree().create_timer(0.2).timeout
	#actor.flip()
	#await get_tree().create_timer(0.2).timeout

	
	self.target_y = actor.get_floor_above_y()
	
	#tween = create_tween()
	#tween.tween_property(actor, "position", Vector2(actor.position.x, self.target_y), 0.7)
	#
	#tween.finished.connect( func() -> void: self.finished.emit("FALLING"))
	#tween.finished.connect( self.exit)



func exit() -> void:
	if(tween) :
		tween.kill()
	
	
func _ready() -> void:
	self.main_animation = "RUN"
	
	pass # Replace with function body.


func physics_update(delta: float) -> void:
	var actor = self.body

	if(!is_jumping) :
		if (windup_timer <= 0): 
			actor.flip()
			windups += 1
			windup_timer = 0.2
		
		if(windups >= 2):
			is_jumping = true 
		windup_timer -= delta 
		
	else: 
		actor.position.y = move_toward(actor.position.y, target_y, delta * jump_speed)	

		if(is_equal_approx(actor.position.y, target_y)):
			actor.sm_locomotion.state.finished.emit("FALLING")

	pass
	#
	#await get_tree().create_timer(1).timeout
	#actor.velocity.y = -50
	#self.finished.emit("FALLING")

	
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
