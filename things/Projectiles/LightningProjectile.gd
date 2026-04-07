class_name LightningProjectile extends CharacterBody2D


const max_speed: float = 500.0
const acceleration: float = 1200
var direction: Vector2 = Vector2.RIGHT
var shooting: bool = false

@onready var timer : Timer = $Timer
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void: 
	
	timer.timeout.connect( func() -> void:
		shooting = true	
		pass
	)
	
	hitbox.area_entered.connect(hitBoxAreaEntered)
	
	

func hitBoxAreaEntered(area: Area2D) -> void:
	
	var areaOwner = area.get_parent() 
	if areaOwner is Enemy :
		areaOwner.sm_locomotion.state.finished.emit("FALLING")
		areaOwner.sm_status.state.finished.emit("DEAD")
		areaOwner.rotation = 0
	
	if areaOwner is Player:
		#Player should play some kind of animation, and move slower while in contact
		pass
		
	else:
		queue_free()	
		
	
	

func _physics_process(delta: float) -> void:
	
	if( shooting ):
		velocity.x = move_toward(velocity.x, max_speed, delta * acceleration) *direction.x
	
	move_and_slide()
	
	
	if( get_slide_collision_count() > 0 ) :
		queue_free()
