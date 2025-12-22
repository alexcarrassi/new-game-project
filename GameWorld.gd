class_name GameWorld extends Node

@export var playerScene: PackedScene
@export var playerHUDScene: PackedScene
var level: Level
@onready var UI: WorldUI = $UI
@onready var NextLevelMarker: Marker2D = $NextLevelMarker
@onready var TransitionSlots: Node = $TransitionSlots


@export var level_debug: PackedScene
@export var start_debug: bool
@export var start_level_index: int = 0

var is_transitioning_Levels : bool = false

func _ready() -> void:
	
	Game.register_gameWorld( self )
	
	var startingLevel
	
	if( self.start_debug) :
		startingLevel = self.level_debug.instantiate() as Level
		self.add_child(startingLevel)

	else:
		startingLevel = createNexLevel( self.start_level_index )
		
	startingLevel.position = Vector2.ZERO
	
	self.swapLevels(startingLevel)
	var player = self.createPlayer(0, self.playerScene)
	self.UI.visible = false

	self.startLevel(startingLevel)
	
func levelTransition() -> void:
	print("TRANSITION")
	self.is_transitioning_Levels = true
	self.level.levelTimer.paused = true
	
	self.cleanHurryEnemies()

	for pickup in get_tree().get_nodes_in_group("Pickups"):
		pickup.queue_free()
	# Hide the UI 
	self.UI.visible = false 
	# First, we find the next level id
	var nextLevel_id = Game.getNextLevel_id()

	if(nextLevel_id == -1) :
		print("No Next level found.")
		nextLevel_id = 0
	
	# We create it and place it in the world
	var nextLevel = createNexLevel(nextLevel_id)
	# Then we set our players to the Respawning state 
	#move the Levels
	var moveLevelTween = self.moveLevels(	self.level, nextLevel)
	await moveLevelTween.finished
	self.swapLevels(nextLevel)
	Game.currentLevel = nextLevel_id


		
	self.is_transitioning_Levels = false
	self.startLevel(nextLevel)

	
func startLevel(level: Level) -> void:
	#spawn the plauyer
	#connect the levelTimer to the hurryUp sequence
	if( level.hurry ) :
		level.hurry.connect( self.onLevelHurry)

		
	if(level.playerSpawns.get_children().size() == 0 ):
		await get_tree().create_timer(2.0).timeout
		self.levelTransition()	
	else:
		
		if(self.start_debug) :
			#quickstart
			pass
		else:
			#cinematic movement
			var movePlayersTween = self.movePlayersToSpawn()
			if( movePlayersTween) :
				await movePlayersTween.finished
			
		self.spawnPlayers()
		self.UI.visible = true	

		
		if( level.enemy_spawns) :
			for actorSpawn in level.enemy_spawns.get_children():
				var spawner = actorSpawn as ActorSpawn
				spawner.deferSpawn()
			
			pass

func movePlayersToSpawn() -> Tween: 
	var moveTween: Tween = create_tween() 
	
	if(self.level.playerSpawns.get_children().size() == 0):
		return null
	
	for player_index: int in Game.players.keys():
		var player: Player = Game.players[player_index]
		var spawnPoint = self.level.getPlayerSpawn( player.player_index)
		
		moveTween.parallel().tween_property(player, "position", spawnPoint.position, 2)
	return moveTween

		
func moveLevels( currentLevel: Level, nextLevel: Level ) -> Tween:
	var tween_next: Tween = create_tween( )
	tween_next.tween_property(nextLevel, "position", Vector2.ZERO, 3)
	tween_next.parallel().tween_property(currentLevel, "position", Vector2(0, -256), 3)
	return tween_next
	
func swapLevels(nextLevel: Level) -> void:
	if( self.level) :
		self.level.queue_free()
	self.level = nextLevel
	

func suspendPlayer(index: int) -> void:
	var player = Game.players[index] 
	if(!player):
		return
		
	player.sm_status.state.finished.emit("SUSPENDED")
	player.position = player.global_position
		
	player.reparent(self)
	
	var transitionSlot = getTransitionSlot(player.player_index)
	var transitionTween = create_tween()
	transitionTween.tween_property(player, "global_position", transitionSlot.global_position, 2)
		

# Puts all players at thei suspend point 
func suspendPlayers() -> void:
	for key: int in Game.players.keys():
		self.suspendPlayer(key)
	


#Creates the player at their suspend point
func createPlayer(index: int, player:PackedScene ) -> Player:
	var playerNode = Game.players.get(0, null)
	if(playerNode == null):
		playerNode = player.instantiate() as Player
		Game.register_player(index, playerNode)
		self.add_child( playerNode )
		
		playerNode.sm_status.state.finished.emit("SUSPENDED")
		var transitionSlot = getTransitionSlot(playerNode.player_index)
		playerNode.global_position = transitionSlot.global_position
		
		playerNode.actorHurt.connect( self.onActorHurt )
		playerNode.actorDeath.connect( self.onActorDeath )
		self.spawnPlayerHUD( self.playerHUDScene, playerNode )

	return playerNode


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

	
func cleanHurryEnemies() -> void:
	for hurryEnemy in get_tree().get_nodes_in_group("Invulnerable")	:
		hurryEnemy.queue_free()

func spawnPlayerHUD( hudScene: PackedScene, player: Player) -> void:
	var playerHUD = hudScene.instantiate()
	playerHUD.player = player
	self.UI.add_child(playerHUD) 
	

func spawnEnemy(enemyScene: PackedScene, position: Vector2, spawnNode: Node = null) -> Enemy:
	var enemy = enemyScene.instantiate() as Enemy
	enemy.position = position
	

	enemy.actorDeath.connect( self.onEnemyDeath)
	if(spawnNode != null) :
		spawnNode.add_child(enemy)
	else :
		self.level.enemies.add_child(enemy)	
	return enemy


func onEnemyDeath(enemy: Enemy) -> void:
	print("Enemy Death in World")
	if(level.is_cleared() and !self.is_transitioning_Levels):
		print("LEVEL OVER")
		await get_tree().create_timer(2.0).timeout
		self.suspendPlayers()
		self.levelTransition()		

func onPlayerDeath(player: Player) -> void:
	Game.deregister_player(0)	
	

func onActorDeath( actor: Actor) -> void:
	if(actor is Player):
		self.onPlayerDeath(actor)
	actor.queue_free()	

func getTransitionSlot( player_index: int) -> Marker2D:

	var slotname = "P%d" % [player_index] 
	
	var slot = self.TransitionSlots.find_child(slotname) as Marker2D
	if( slot.is_inside_tree( )):
		return slot
		
	return null

func onActorHurt( actor: Actor) -> void:
	if (actor is Player) :
		self.cleanHurryEnemies()
		self.level.levelTimer.start()

			

func onLevelHurry() -> void:
	var hurryTween = self.UI.showHurry()
	hurryTween.finished.connect( self.endLevelHurry)
	get_tree().paused = true
	
func endLevelHurry() -> void:
	get_tree().paused = false	
	self.level.spawnHurryEnemy()
