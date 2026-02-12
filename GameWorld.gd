class_name GameWorld extends Node

@export var playerScene: PackedScene
@export var playerHUDScene: PackedScene
@export var playerStats_Schema: Resource
var level: Level
@onready var UI: WorldUI = $UI
@onready var NextLevelMarker: Marker2D = $NextLevelMarker
@onready var TransitionSlots: Node = $TransitionSlots

@onready var extendBubbleSpawner_left: ExtendBubbleSpawner  = $ExtendBubble_left
@onready var extendBubbleSpawner_right: ExtendBubbleSpawner = $ExtendBubble_right


@export var level_debug: PackedScene
@export var start_debug: bool
@export var start_level_id: String = "0"



var is_transitioning_Levels : bool = false

func _ready() -> void:
	
	Game.register_gameWorld( self )
	var startingLevel = createNextLevel( self.start_level_id )	
	startingLevel.position = Vector2.ZERO
	
	self.swapLevels(startingLevel)
	var player = self.createPlayer(0, self.playerScene)
	self.UI.visible = false

	self.startLevel(startingLevel)
	
func levelTransition(options: Dictionary = {}) -> void:
	print("TRANSITION")
	
	# Set state
	self.is_transitioning_Levels = true
	self.level.levelTimer.paused = true
	

	

	# Reparent the players
	for key: int in Game.playerEntries.keys():
		if(Game.playerEntries[key]):
			Game.playerEntries[key].player.reparent(self)
	
	if( options.has("timeout")):
		await get_tree().create_timer(options["timeout"]).timeout

	# Cleanup, after timeout
	self.level.cleanup()

	# Create and Ready the next level
	# Get the next Level's id. Either from the options or the logical next level		
	var nextLevel_id = options.get("nextLevel_id", Game.getNextLevel_id())

	if(nextLevel_id == "") :
		print("No Next level found.")
		nextLevel_id = ""
	
	var nextLevel = createNextLevel(nextLevel_id)
	
	
	if(options.has("cinematic")):
		if(options["cinematic"]) :
			#Put the players in Suspended Animation
			self.suspendPlayers()
			# Hide the UI 
			self.UI.visible = false 
			
			#move the Levels
			var moveLevelTween = self.tweenLevels(	self.level, nextLevel)
			await moveLevelTween.finished
			
	self.swapLevels(nextLevel)
	
	
	if(options.has("cinematic")):
		if(options["cinematic"]) :
			#cinematic movement
			var movePlayersTween = self.tweenPlayersToSpawn()
			if( movePlayersTween) :
				await movePlayersTween.finished
	
			
	self.startLevel(nextLevel)


# The level contains an array of ActorSpawns.  
# We call the spawning functions on each of them, which return Tweens for their transport.
# The Tweens function as Promises, which we all wire up with their corresponding "finished" signal.
# Upong finishing, we check if the remaining Tweens have been sucessfully finished.
# If so, we can offically start the level by setting all the actors of the spawn to their ALIVE state
	
func startLevel(level: Level) -> void:
	#spawn the plauyer
	#connect the levelTimer to the hurryUp sequence
	if( level.hurry ) :
		level.hurry.connect( self.onLevelHurry)

	if(level.playerSpawns.get_children().size() == 0 ):
		#No level-start marker for the players, so move on to the next level
		self.levelTransition({"cinematic": true, "timeout" : 2.0})	
	else:
		self.spawnPlayers()
		self.UI.visible = true	
		
		var transportTweens: Array[Tween] = []	
		
		if( !level.enemy_spawns) :
			return
			
		var children = level.enemy_spawns.get_children() as Array[Node]
		for actorSpawn: ActorSpawn in children:
			
			if( actorSpawn.disabled) :
				continue
				
			var transportTween = actorSpawn.spawnActor()
			transportTweens.append( transportTween )
			transportTween.finished.connect( func () -> void:
				for transportTween_: Tween in transportTweens:
					
					if( transportTween_.is_running()) :
						return
					
				#all tweens are done. Activate the actors.	
				
				for actorSpawn_: ActorSpawn in children :
					if(actorSpawn_.actor):
						actorSpawn_.actor.sm_status.state.finished.emit("ALIVE")
				self.is_transitioning_Levels = false
			)


	# Queue the Items for the Item spawns	
	if(level.item_spawns):
		var itemSpawns = level.item_spawns.get_children() as Array[ItemSpawn]
			
		for itemSpawn in itemSpawns:
			pass	

# When starting a new level, a player may have earned one or more Items to spawn,
# based on actions taken throughout the game
func queue_items_for_spawn(playerKey: int) -> void:
	pass	



# When starting a new level, a player may have earned one or more extend bubbles
# This function checks each Player, and queues the bubbles they earned
func queue_extend_bubbles(playerKey: int) -> void:
	var player = Game.playerEntries[playerKey].player
	var bubble_count = player.current_comboRecord - 1
	var spawner = self.extendBubbleSpawner_left if playerKey  % 2 == 0 else extendBubbleSpawner_right
	var bubbleQueue = player.getEligibleExtendBubbles(bubble_count)		
	spawner.bubbleQueue = bubbleQueue

			
	
	print("Queueing  %d bubbles" %[player.current_comboRecord - 1])
	
	
	spawner.disabled = false 
	spawner.intervalTimer.start()
	player.current_comboRecord = 0	

func tweenPlayersToSpawn() -> Tween: 
	var moveTween: Tween = create_tween() 
	
	if(self.level.playerSpawns.get_children().size() == 0):
		return null
	
	for player_index: int in Game.playerEntries.keys():
		var player: Player = Game.playerEntries[player_index].player
		var spawnPoint = self.level.getPlayerSpawn( player.player_index)
		
		moveTween.parallel().tween_property(player, "position", spawnPoint.position, 1)
	return moveTween

		
func tweenLevels( currentLevel: Level, nextLevel: Level ) -> Tween:
	var tween_next: Tween = create_tween( )
	tween_next.tween_property(nextLevel, "position", Vector2.ZERO, 2.0)
	tween_next.parallel().tween_property(currentLevel, "position", Vector2(0, -256), 2.0)
	return tween_next
	
func swapLevels(nextLevel: Level) -> void:
	if( self.level) :
		self.level.queue_free()
	self.level = nextLevel
	nextLevel.position = Vector2.ZERO

	

func suspendPlayer(index: int) -> void:
	var player = Game.playerEntries[index].player
	if(!player):
		return
		
	player.sm_status.state.finished.emit("SUSPENDED")
	player.position = player.global_position
		
	var transitionSlot = getTransitionSlot(player.player_index)
	var transitionTween = create_tween()
	transitionTween.tween_property(player, "global_position", transitionSlot.global_position, 2)
		

# Puts all players at thei suspend point 
func suspendPlayers() -> void:
	for key: int in Game.playerEntries.keys():
		self.suspendPlayer(key)
	


#Creates the player at their suspend point
func createPlayer(index: int, player:PackedScene ) -> Player:
	var playerEntry = Game.playerEntries.get(0, null)
	var playerNode = null 
	if(playerEntry == null):
		playerNode = player.instantiate() as Player
		playerEntry = Game.register_player(index, playerNode)
		self.add_child( playerNode )
		
		playerNode.sm_status.state.finished.emit("SUSPENDED")
		var transitionSlot = getTransitionSlot(playerNode.player_index)
		playerNode.global_position = transitionSlot.global_position
		playerNode.player_index = index
		
		playerNode.actorHurt.connect( self.onActorHurt )
		playerNode.actorDeath.connect( self.onActorDeath )
		playerEntry.inventory.inventoryUpdated.connect( self.tryExtend.bind(playerNode))
		self.spawnPlayerHUD( self.playerHUDScene, playerEntry )

			
	return playerNode

func tryExtend( player: Player) -> void:
	#Check if we need to extend
	if(player.checkForExtend()):
		player.health += 1
		player.cleanExtendBubbles()
		player.actorLifeUp.emit(player)
		self.levelTransition({"cinematic": true, "timeout" : 0.1})	
	
			
		
	
# Puts players in the current level, Positions them at the spawn point, set state to ALIVE
func spawnPlayers() -> void:
	for key: int in Game.playerEntries.keys():
		var player = Game.playerEntries[key].player
		player.reparent(self.level)
		var spawnPoint = self.level.getPlayerSpawn( player.player_index)
		player.position = spawnPoint.position
		player.sm_status.state.finished.emit("ALIVE")
		self.queue_extend_bubbles(key)		
		self.queue_items_for_spawn(key)
			
		
func createNextLevel(level_id: String) -> Level:
	var nextLevelDefinition = Game.getLevelById( level_id)
	if(nextLevelDefinition):
		
		var nextLevel = nextLevelDefinition.scene.instantiate() as Level
		nextLevel.definition = nextLevelDefinition
		nextLevel.position = self.NextLevelMarker.position
		self.add_child(nextLevel)
	
		return nextLevel	
	
	return null	

func spawnPlayerHUD( hudScene: PackedScene, playerEntry: PlayerEntry) -> void:
	var playerHUD = hudScene.instantiate()
	playerHUD.playerEntry = playerEntry
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
		
		self.is_transitioning_Levels = true
		self.levelTransition({"cinematic": true, "timeout" : 2.0})		

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
		self.level.cleanHurryEnemies()
		self.level.levelTimer.start()

func onActorSpawned() -> void:
	
	pass
			

func onLevelHurry() -> void:
	var hurryTween = self.UI.showHurry()
	hurryTween.finished.connect( self.endLevelHurry)
	get_tree().paused = true
	
func endLevelHurry() -> void:
	get_tree().paused = false	
	self.level.spawnHurryEnemy()
