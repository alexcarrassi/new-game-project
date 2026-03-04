class_name WaterProjectile extends CharacterBody2D



@export var tideSpeed: float = 210.0
@onready var tidePath: Path2D = $Path2D
@onready var tidePathFollow: PathFollow2D = $Path2D/PathFollow2D
@onready var hitBox: Area2D = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D

var dir: Vector2 = Vector2.RIGHT
var projectileSpeed: float = 220.0

var sprite_flicker_hz = 60.0
var isGrounded: bool = false
var actors: Array[Actor] = []


var _flicker_accum: float = 0.0

func _ready() -> void:	
	self.tidePath.set_as_top_level(true)
	self.tidePath.curve = Curve2D.new()
	self.hitBox.area_entered.connect( self.hitBoxAreaEntered)


func hitBoxAreaEntered(area: Area2D) -> void:
	var areaOwner = area.get_parent()
	if areaOwner is Enemy:
		areaOwner.sm_locomotion.state.finished.emit("FALLING")
		areaOwner.sm_status.state.finished.emit("DEAD", {"dir": self.dir.x})
		areaOwner.rotation = 0
	
	if areaOwner is Player:
		if(areaOwner.sm_locomotion.state.name != "RIDING"):
			areaOwner.sm_locomotion.state.finished.emit("RIDING", {"owner": self})

			#Put the Player in tailor made "Riding" state
			self.actors.append (areaOwner)
		


	
func tryAddPathPoint(point: Vector2) -> void:
	var pointCount = self.tidePath.curve.point_count
	self.tidePath.curve.add_point(point, Vector2.ZERO, Vector2.ZERO, clamp(pointCount - 2, 0, pointCount - 1) )	
	
func setPathHead(point: Vector2) -> void:
	var point_count = self.tidePath.curve.point_count
	self.tidePath.curve.add_point( point )
		

	
	
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	var newGround = self.is_on_floor()
	if not is_on_floor():
		self.velocity.y = self.projectileSpeed
		self.velocity.x = 0
	else :
		self.velocity.x = self.dir.x * self.projectileSpeed

	move_and_slide()
	

	#If we're switching states, we need to record that position for the sprite's oscillation	
	if(self.is_on_floor() && !self.isGrounded):
		self.dir.x *= -1

	else:
		self.setPathHead( self.position )
		
		
	if(newGround != self.isGrounded):
		self.tryAddPathPoint( self.position)
	
	self.isGrounded = self.is_on_floor()

func releaseActors() -> void:
	for actor: Actor in self.actors:

		#actor.reparent(Game.world.level)
		#actor.position = self.position
		actor.sm_locomotion.state.finished.emit("IDLE")

func _process(delta: float) -> void:

	self._flicker_accum += delta
	if(self._flicker_accum >= 1/self.sprite_flicker_hz) :
		self._flicker_accum = 0
		self.tidePathFollow.visible = !self.tidePathFollow.visible 
		self.sprite.visible = !self.tidePathFollow.visible
		
	
	var curve_length = self.tidePath.curve.get_baked_length()
	if(curve_length < 32):
		self.tidePathFollow.progress = 0
	
	else:
		#var progress_ofsset = clamp(curve_length - 32, 0, curve_length  -32)
		self.tidePathFollow.progress +=  self.tideSpeed*delta
		
	for actor: Actor in self.actors:
		actor.direction.x = self.dir.x	
	
		
		
	if( curve_length > 0 && self.tidePathFollow.progress == curve_length ) :
		self.queue_free()
		self.hitBox.monitoring = false
		self.hitBox.monitorable = false
		self.releaseActors()


		
