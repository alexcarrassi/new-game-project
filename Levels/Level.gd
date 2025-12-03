class_name Level extends Node2D

@onready var p1_Start: Node2D = $p1_Start
@onready var bubbleDestination: Node2D = $Bubble_Destination
@onready var levelTimer: Timer = $Level_Timer
@onready var hurrySpawn: ActorSpawn = $Hurry_Enemy_spawn
@onready var enemy_spawns: Node = $Enemy_Spawns
@onready var enemies: Node = $Enemies


signal hurry()

# Span the player
# Connect the timer's timeout to the Hurry Up event
func _ready() -> void:
	self.levelTimer.timeout.connect( self.onHurryUp)
	pass # Replace with function body.

# Flash the Hurry message, pause during it. Spawn Skel-Monsta after a few seconds.
func onHurryUp() -> void:
	self.hurry.emit()

func spawnHurryEnemy() -> void:
	if(self.hurrySpawn != null) :
		self.hurrySpawn.deferSpawn()

func getHurrySpawn() -> ActorSpawn:
	return self.hurrySpawn
	
func is_cleared() -> bool:
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemies"):
		
		if !enemy.is_in_group("Invulnerable") and enemy.sm_status.state.name != "DEAD":
			return false
		
	print("LEVEL CLEARED")	
	return true	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
