class_name GameWorld extends Node

@export var playerScene: PackedScene
@export var levelScene : PackedScene
@export var playerHUDScene: PackedScene
var playerNode: Player
var level: Level
@onready var UI: WorldUI = $UI

func _ready() -> void:
	
	Game.register_gameWorld( self )
	
	self.startLevel( self.levelScene)
	
	var player = self.spawnPlayer( self.playerScene )
	
	self.spawnPlayerHUD( playerHUDScene, player )


func startLevel(levelScene: PackedScene) -> void:
	#spawn the plauyer
	#connect the levelTimer to the hurryUp sequence
	self.level = levelScene.instantiate() 
	self.add_child(level)
	level.hurry.connect( self.onLevelHurry)
	for actorSpawn in level.enemies.get_children():
		var spawner = actorSpawn as ActorSpawn
		spawner.deferSpawn()
	
	Game.register_currentLevel(level)
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
	

	self.level.add_child(enemy)	
	return enemy


func onPlayerDeath(player: Player) -> void:
	Game.deregister_player(0)	

func onActorDeath( actor: Actor) -> void:
	if(actor is Player):
		self.onPlayerDeath(actor)
		
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
