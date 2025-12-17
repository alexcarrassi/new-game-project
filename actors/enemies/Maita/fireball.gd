class_name Fireball extends RigidBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var CollisionShape: CollisionShape2D = $CollisionShape2D
@onready var Hitbox: Area2D = $Hitbox
var dir: Vector2 = Vector2.RIGHT
var speed = 100.0
var projectile_owner: Actor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.gravity_scale = 0
	self.animationPlayer.play("moving")
	self.body_entered.connect( self.onBodyEntered)
	self.contact_monitor = true
	self.max_contacts_reported = 3
	self.animationPlayer.animation_finished.connect(self.onAnimationFinished)
	self.Hitbox.monitoring = true
	self.Hitbox.area_entered.connect( self.onHitboxAreaEntered )
	
	pass # Replace with function body.


func onHitboxAreaEntered( hitbox: Area2D ) :
	var actor = hitbox.get_parent() 
	if( actor is Player ):
		actor.sm_status.state.finished.emit("HURT")
		self.explode()
		
	pass

func onAnimationFinished( anim_name: StringName) -> void:
	if(anim_name == &"Explode"):
		self.queue_free()
	
func explode() -> void:
	var explodeLength = self.animationPlayer.get_animation("Explode")
	self.contact_monitor = false
	self.animationPlayer.play("Explode")
	
	
func onBodyEntered( body: Node) -> void:
	print(body)
	
	self.explode()


func onPlayerCollide( player: Player) -> void:
	player.sm_status.state.finished.emit("HURT")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	self.position += self.dir * self.speed	* delta
