class_name Enemy extends Actor

@onready var sensors: Node2D = $Sensors
@onready var decision_timer: Timer = $Decision_Timer
var rng = RandomNumberGenerator.new()
@export var DECISION_PERIOD = 0.33
@export var LootTable : Array[PickupData] = []
@export var pickup : PackedScene
	
var intent: EnemyIntent

func _ready() -> void:
	super._ready()
	
	self.intent = EnemyIntent.new()
		#self.animationPlayer.sm_locomotion = self.sm_locomotion
	if(self.sensors) :
		
		$Sensors.scale.x = self.direction.x
	
	self.rng.randomize()
	if(self.decision_timer) :
		self.decision_timer.wait_time = self.DECISION_PERIOD
		self.decision_timer.one_shot = true
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
		
	
func player_above() -> int:
	if(Game.players.is_empty()) :
		return 0
	
	var player = Game.players[0] as Player
	var margin = 12.0
	
	if( player.position.y < self.position.y - margin) :
		return 1
	elif( player.position.y > self.position.y + margin )	:
		return -1
	else :
		return 0	
 
	pass
	
func wall_ahead() -> bool:
	var sensor_wall_front = $Sensors/Wall_front as RayCast2D
	return sensor_wall_front.is_colliding()
	 
func floor_above() -> bool: 
	var sensor_floor_above = $Sensors/Floor_above as RayCast2D
	return sensor_floor_above.is_colliding()

func floor_front() -> bool:
	var sensor_floor_front = $Sensors/Floor_front as RayCast2D 
	return sensor_floor_front.is_colliding()
	
# Assess current situation, state your intents
func think()-> void:
	if(self.decision_timer.time_left <= 0):
		self.decision_timer.wait_time = self.DECISION_PERIOD
		self.decision_timer.start()
	var position_compared_to_player = self.player_above()


	if( position_compared_to_player == 1 and self.floor_above()) :
		self.intent.locomotion = &"JUMP_UP"
		#self.finished.emit("JUMP_UP")
		
	
	
func flip() -> void:
	var sensor_wall_front = $Sensors/Wall_front as RayCast2D
	var sensor_floor_front = $Sensors/Floor_front as RayCast2D 
	
	self.direction.x *= -1
	sensor_wall_front.position.x *= -1
	sensor_wall_front.target_position.x *= -1
	sensor_floor_front.position.x *= -1
	sensor_floor_front.target_position.x *= -1

	self.sprite2D.flip_h = self.direction.x > 0.0

func onPlayerCollide( player: Player) -> void:
	player.sm_status.state.finished.emit("HURT")
