class_name Enemy extends Actor

@onready var sensors: Node2D = $Sensors
@onready var decision_timer: Timer = $Decision_Timer
var rng = RandomNumberGenerator.new()
@export var DECISION_PERIOD = 0.33
@export var LootTable : Array[PickupData] = []
@export var pickup : PackedScene
	

func _ready() -> void:
	super._ready()
	self.rng.randomize()

		#self.animationPlayer.sm_locomotion = self.sm_locomotion
	if(self.sensors) :
		
		$Sensors.scale.x = self.direction.x
	
	if(self.decision_timer) :
		self.decision_timer.wait_time = self.DECISION_PERIOD
		self.decision_timer.one_shot = true
		self.decision_timer.timeout.connect(self.think)
	pass
	
	
func instantiateLoot() -> Pickup:
	
	# We'd normally do a weighted lookup, but right now, just get the first available one
	if(self.LootTable.size() > 0):

		var newPickup : Pickup = pickup.instantiate()
		var pickupData = self.LootTable[0]

		get_tree().root.add_child( newPickup )
		newPickup.setData( pickupData )
		newPickup.applyPickupData()
		newPickup.position = self.position
		
		return newPickup
		
	return null	

func get_targetPlayer() -> Player: 
	if( Game.players.is_empty()) :
		return null
	
	return Game.players[0]			
	
func player_above() -> int:
	if(Game.players.is_empty()) :
		return 0
	
	var player = self.get_targetPlayer()
	var margin = 12.0
	
	if( player.position.y < self.position.y - margin) :
		return 1
	elif( player.position.y > self.position.y + margin )	:
		return -1
	else :
		return 0	
 
	pass
	
func isFacing(node: Node) -> bool:
	if( node == null) :
		return false 
		
	var distance = self.position.distance_to( node.position )

	var pos = node.position - self.position
		#if my position is greater then yours: i am on the right. else: left.
	
	return sign(self.direction.x) == sign(pos.x)

func wall_ahead() -> bool:
	var sensor_wall_front = $Sensors/Wall_front as RayCast2D
	if(!sensor_wall_front):
			return false
			
	return sensor_wall_front.is_colliding()
	 
func floor_above() -> bool: 
	var sensor_floor_above = $Sensors/Floor_above as RayCast2D
	if(!sensor_floor_above):
		return false
		
	return sensor_floor_above.is_colliding()

#Sensor gets the bottom of the tile above. Actor's local origin is in the middle of their collision shape.
#So to get the floor's y, we need the collision position, + tile size + half the actor's height.
func get_floor_above_y() -> float:
	var sensor_floor_above = $Sensors/Floor_above as RayCast2D
	var collision_point = sensor_floor_above.get_collision_point().y
	var shape_offset = self.collisionShape.shape.get_rect().size.y /2 

	var current_tilesize = Game.world.level.Tiles.tile_set.tile_size
	
	return sensor_floor_above.get_collision_point().y - shape_offset - current_tilesize.y

func floor_front() -> bool:
	var sensor_floor_front = $Sensors/Floor_front as RayCast2D 
	return sensor_floor_front.is_colliding()
	
# Assess current situation, state your intents\
func think()-> void:
	
	self.decision_timer.wait_time = self.DECISION_PERIOD
		
	var random_number = rng.randf()
	print(random_number)
	var position_compared_to_player = self.player_above()
	if(random_number < 0.7):
		if( position_compared_to_player == 1 and self.floor_above()) :
			self.intent.locomotion = &"JUMP_UP"
	
	self.decision_timer.start()

func flip_y() -> void:
	self.direction.y *= -1	

func flip() -> void:
	var sensor_wall_front = $Sensors/Wall_front as RayCast2D
	var sensor_floor_front = $Sensors/Floor_front as RayCast2D 
	
	self.direction.x *= -1
	if( sensor_wall_front ):
		sensor_wall_front.position.x *= -1
		sensor_wall_front.target_position.x *= -1
		
	if( sensor_floor_front ):
		sensor_floor_front.position.x *= -1
		sensor_floor_front.target_position.x *= -1

	self.sprite2D.flip_h = self.direction.x > 0.0

func onPlayerCollide( player: Player) -> void:
	player.sm_status.state.finished.emit("HURT")
