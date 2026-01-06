class_name Level extends Node2D

@onready var p1_Start: Node2D = $p1_Start
@onready var playerSpawns: Node = $Player_Spawns
@onready var bubbleDestination: Node2D = $Bubble_Destination
@onready var levelTimer: Timer = $Level_Timer
@onready var hurrySpawn: ActorSpawn = $Hurry_Enemy_spawn
@onready var enemy_spawns: Node = $Enemy_Spawns
@onready var enemies: Node = $Enemies
@onready var Tiles: TileMapLayer = $Tiles


var definition: LevelDefinition

signal hurry()

# Span the player
# Connect the timer's timeout to the Hurry Up event
func _ready() -> void:
	if(self.levelTimer) :
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
	
func getPlayerSpawn(player_index: int) -> Node2D:
	
	
	var spawnName = "p%d_Start" % [player_index +1]
	var playerSpawn = self.playerSpawns.find_child(spawnName)
	
	if playerSpawn == null:
		playerSpawn = self.playerSpawns.get_child(0)
	
	return playerSpawn	

func cleanup() -> void:
	var bubbles = self.find_children("*", "Bubble", true, false)
	for bubble: PlayerBubble in bubbles:
		bubble.pop()
	
	self.cleanHurryEnemies()
	self.cleanEnemies()
	self.cleanPickups()

	pass
	
func cleanPickups() -> void:
	for pickup in get_tree().get_nodes_in_group("Pickups"):
		pickup.queue_free()
	
func cleanHurryEnemies() -> void:
	for hurryEnemy in get_tree().get_nodes_in_group("Invulnerable")	:
		hurryEnemy.queue_free()
	
func cleanEnemies() -> void:
	var enemies = self.find_children("*", "Enemy", true, false)	
	for enemy: Enemy in enemies:
		enemy.queue_free()
	
func is_cleared() -> bool:
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemies"):
		
		if !enemy.is_in_group("Invulnerable") and enemy.sm_status.state.name != "DEAD":
			return false
		
	print("LEVEL CLEARED")	
	return true	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
