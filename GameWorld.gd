class_name GameWorld extends Node

@export var playerScene: PackedScene
@export var playerHUDScene: PackedScene
var playerNode: Player
var level: Level
@onready var UI: WorldUI = $UI
@onready var NextLevelMarker: Marker2D = $NextLevelMarker

func _ready() -> void:
	
	Game.register_gameWorld( self )
	
	var levelScene = Game.getLevelById( 0 )
	var nextLevel = createNexLevel( 0 )
	nextLevel.position = Vector2.ZERO
	
	self.swapLevels(nextLevel)
	self.startLevel( nextLevel)
	
	var player = self.spawnPlayer( self.playerScene )
	self.spawnPlayerHUD( playerHUDScene, player )

func levelTransition() -> void:
	self.level.levelTimer.paused = true

	await get_tree().create_timer(2.0).timeout

	for pickup in get_tree().get_nodes_in_group("Pickups"):
		pickup.queue_free()
		
	# Hide the UI 
	self.UI.visible = false 
	# First, we find the next level id
	var nextLevel_id = Game.getNextLevel_id()

	if(nextLevel_id == -1) :
		print("No Next level found.")
		return
	
	print( nextLevel_id)
	
	# We create it and place it in the world
	var nextLevel = createNexLevel(nextLevel_id)
	# Then we set our players to the Respawning state 
	
	self.respawnPlayers()
	
	#move the Levels
	var moveTween = self.moveLevels(	self.level, nextLevel)
	await moveTween.finished
	
	self.swapLevels(nextLevel)
	self.spawnPlayers()
	self.UI.visible = true
	
	self.startLevel(nextLevel)
	
	
	
	
	
func moveLevels( currentLevel: Level, nextLevel: Level ) -> Tween:
	var tween_next: Tween = create_tween( )
	tween_next.tween_property(nextLevel, "position", Vector2.ZERO, 3)
	tween_next.parallel().tween_property(currentLevel, "position", Vector2(0, -256), 3)
	return tween_next
	
func swapLevels(nextLevel: Level) -> void:
	if( self.level) :
		self.level.queue_free()
	self.level = nextLevel
	

func respawnPlayers() -> void:
	for key: int in Game.players.keys():
		var player = Game.players[key]
		player.sm_status.state.finished.emit("SPAWNING")
		player.position = player.global_position
		player.reparent(self)
		
	
func spawnPlayers() -> void:
	for key: int in Game.players.keys():
			var player = Game.players[key]
			player.sm_status.state.finished.emit("ALIVE")
			player.reparent(self.level)
		
func createNexLevel(level_id: int) -> Level:
	var nextLevelScene = Game.getLevelById( level_id)
	var nextLevel = nextLevelScene.instantiate() as Level
	nextLevel.position = self.NextLevelMarker.position
	self.add_child(nextLevel)
	
	return nextLevel


func startLevel(level: Level) -> void:
	#spawn the plauyer
	#connect the levelTimer to the hurryUp sequence
	level.hurry.connect( self.onLevelHurry)
	for actorSpawn in level.enemies.get_children():
		var spawner = actorSpawn as ActorSpawn
		spawner.deferSpawn()
	
	pass

func spawnPlayer(player: PackedScene) -> Player :
	
	self.playerNode = player.instantiate()
	
	playerNode.position = self.level.p1_Start.position
	playerNode.Bubble_Destination = self.level.bubbleDestination
			
	self.level.add_child(playerNode)

	playerNode.actorDeath.connect( self.onActorDeath)
	playerNode.actorHurt.connect( self.onActorHurt )	
		
	Game.register_player(0, playerNode)	
	#for enemyNode in get_tree().get_nodes_in_group("Enemies"):
		#var enemy = enemyNode as Enemy
		#enemy.players.append( playerNode )	
		#
	#playerNode.scoreUpdated.connect( )	
	return self.playerNode as Player

func spawnPlayerHUD( hudScene: PackedScene, player: Player) -> void:
	var playerHUD = hudScene.instantiate()
	playerHUD.player = player
	self.UI.add_child(playerHUD) 
	

func spawnEnemy(enemyScene: PackedScene, position: Vector2) -> Enemy:
	var enemy = enemyScene.instantiate() as Enemy
	enemy.position = position
	

	enemy.tree_exited.connect( self.onEnemyDeath)
	self.level.add_child(enemy)	
	return enemy


func onEnemyDeath() -> void:
	
	if(get_tree() != null):
		
		var enemies = get_tree().get_nodes_in_group("Enemies")

		print(enemies.size())
		if(enemies.is_empty() ):
			#transitionLevel
			print("LEVEL OVER")

			self.levelTransition()		

func onPlayerDeath(player: Player) -> void:
	Game.deregister_player(0)	

func onActorDeath( actor: Actor) -> void:
	if(actor is Player):
		self.onPlayerDeath(actor)
	elif( actor is Enemy) :	
		var enemies = get_tree().get_nodes_in_group("Enemies")
		
		print(enemies.size())
		if(enemies.is_empty() ):
			#transitionLevel
			print("LEVEL OVER")
			pass
			
	actor.queue_free()	

func onActorHurt( actor: Actor) -> void:
	if (actor is Player) :
		self.level.levelTimer.start()
			

func onLevelHurry() -> void:
	var hurryTween = self.UI.showHurry()
	hurryTween.finished.connect( self.endLevelHurry)
	get_tree().paused = true
	
func endLevelHurry() -> void:
	get_tree().paused = false	
	self.level.spawnHurryEnemy()
