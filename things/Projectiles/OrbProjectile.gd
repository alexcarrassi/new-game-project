class_name OrbProjectile extends Projectile

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox
@onready var timer: Timer = $Timer

@export var SPEED = 100.0

var actor: Actor
var direction: Vector2 = Vector2(-1, -1)

func _ready() -> void:
	super._ready()

	animationPlayer.play("PROPAGATE")
	hitbox.area_entered.connect( onAreaEntered)
	max_slides = 10
	
	timer.timeout.connect( func() -> void:
		dissolve()
	)

func onAreaEntered( area: Area2D) -> void:
	var areaOwner = area.owner
	if(areaOwner is Enemy):
		areaOwner.sm_status.state.finished.emit("DEAD")
		print(areaOwner.name)
	pass
	
	
func _physics_process(delta: float) -> void:
	
	velocity = direction  * SPEED
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_normal = collision.get_normal()

		print(collision_normal)
		if( abs(collision_normal.x) > 0.3):
			direction.x =  clamp(collision_normal.x, -1, 1)
		if(abs(collision_normal.y) > 0.3 ) :
			direction.y =	  clamp(collision_normal.y, -1, 1)
			
