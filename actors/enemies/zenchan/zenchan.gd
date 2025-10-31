class_name Zenchan extends Enemy

@export var DECISION_PERIOD = 0.33

@onready var sensors: Node2D = $Sensors
@onready var decision_timer: Timer = $Decision_Timer

var rng = RandomNumberGenerator.new()
var direction: Vector2 = Vector2.LEFT


func _ready() -> void:
	super._ready()
	
	#self.animationPlayer.sm_locomotion = self.sm_locomotion
	$Sensors.scale.x = self.direction.x
	
	self.rng.randomize()
	self.decision_timer.wait_time = self.DECISION_PERIOD
	self.decision_timer.one_shot = true
	pass
	
	
	
func player_above() -> int:
	var player = get_tree().get_first_node_in_group("player") as Player
	var player_y = player.position.y
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
	
	
func flip() -> void:
	var sensor_wall_front = $Sensors/Wall_front as RayCast2D
	var sensor_floor_front = $Sensors/Floor_front as RayCast2D 
	
	self.direction.x *= -1
	sensor_wall_front.position.x *= -1
	sensor_wall_front.target_position.x *= -1
	sensor_floor_front.position.x *= -1
	self.sprite2D.flip_h = self.direction.x > 0.0

	#self.sprite2D.flip_h
		
func _physics_process(delta: float) -> void:
	pass
