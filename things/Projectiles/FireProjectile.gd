class_name FireProjectile extends CharacterBody2D

var fallingSpeed: float = 80.0

@onready var dissolveTimer: Timer = $DissolveTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitBox: Area2D = $Hitbox
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@export var lifeTime: float = 5.0

var sprite_flicker_hz = 30.0
var _flicker_accum: float = 0
var isGrounded: bool = false
var spawnSegments: bool = true

func _ready() -> void:
	
	self.hitBox.monitorable = false 
	self.hitBox.monitoring = false
	#connect timer with self.queue_free()
	self.dissolveTimer.timeout.connect( func() -> void: 
		self.animationPlayer.play("dissolve")
		var dissolveLength = self.animationPlayer.get_animation("dissolve").length
		await get_tree().create_timer(dissolveLength).timeout
		self.queue_free()
		print("dissolveTimer timeout")	
	)
	
	self.hitBox.area_entered.connect( self.hitBoxAreaEntered)
	self.animationPlayer.play("spawn")

func hitBoxAreaEntered(area: Area2D) -> void:
	
	var areaOwner = area.get_parent() 
	if areaOwner is Enemy :
		areaOwner.sm_locomotion.state.finished.emit("FALLING")
		areaOwner.sm_status.state.finished.emit("DEAD")
		areaOwner.rotation = 0
	
	if areaOwner is Player:
		#Player should play some kind of animation, and move slower while in contact
		pass
	
			
func _physics_process(delta: float) -> void:
	#Fall down
	
	self.velocity.y = self.fallingSpeed
	self.move_and_slide()
	#If grounded	 for the first time 
	
	if(self.is_on_floor() && !self.isGrounded):
		self.isGrounded = true
		self.dissolveTimer.start( self.lifeTime ) 
		self.hitBox.monitorable = true 
		self.hitBox.monitoring = true
		if(self.spawnSegments):
			self.spawnFireSegments()
	#create carpet
	
	pass 
	
	
func spawnFireSegments() -> void:
	var tileMap = Game.world.level.Tiles
	var position = self.global_position
	var local_pos = tileMap.to_local(position)
	var cell: Vector2i = tileMap.local_to_map(local_pos)

	for i in range(-2, 3) :
		var testCell = Vector2i(cell.x - i, cell.y )
		var newLocal = tileMap.map_to_local(testCell)
		var newGlobal = tileMap.to_global(newLocal)
		
		if i == 0:
			self.position =  newGlobal
			continue
			
		var tileData = tileMap.get_cell_tile_data( testCell )
		if(!tileData):

			var projectile = self.duplicate(Node.DUPLICATE_USE_INSTANTIATION)
			projectile.position = newGlobal 
			projectile.spawnSegments = false
			Game.world.level.add_child( projectile )
			pass
		
	pass	
	
		
func _process(delta: float) -> void:
	if(self.isGrounded):
		self._flicker_accum += delta 
		
		if(self._flicker_accum >= 1/self.sprite_flicker_hz) :
			self._flicker_accum = 0
			self.sprite.visible = !self.sprite.visible
	pass	
	
