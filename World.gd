class_name WorldRoot extends Node

@export var playerScene: PackedScene
@export var levelScene : PackedScene
@export var playerHUDScene: PackedScene
var playerNode: Player
var level: Level
@onready var UI: WorldUI = $UI

func _ready() -> void:
	
	self.startLevel( self.levelScene)
	var player = self.spawnPlayer( self.playerScene )
	self.spawnPlayerHUD( playerHUDScene, player )


func startLevel(levelScene: PackedScene) -> void:
	#spawn the plauyer
	#connect the levelTimer to the hurryUp sequence
	self.level = levelScene.instantiate() 
	self.add_child(level)
	level.hurry.connect( self.onLevelHurry)
	pass

func spawnPlayer(player: PackedScene) -> Player :
	
	self.playerNode = player.instantiate()
	
	playerNode.position = self.level.p1_Start.position
	playerNode.Bubble_Destination = self.level.bubbleDestination
			
	self.level.add_child(playerNode)

	playerNode.actorDeath.connect( self.onActorDeath)
	playerNode.actorHurt.connect( self.onActorHurt )	
		
	for enemyNode in get_tree().get_nodes_in_group("Enemies"):
		var enemy = enemyNode as Enemy
		enemy.players.append( playerNode )	
		
	#playerNode.scoreUpdated.connect( )	
	return self.playerNode as Player

func spawnPlayerHUD( hudScene: PackedScene, player: Player) -> void:
	var playerHUD = hudScene.instantiate()
	playerHUD.player = player
	self.UI.add_child(playerHUD) 
	

func spawnEnemy(enemyScene: PackedScene, position: Vector2) -> void:
	var enemy = enemyScene.instantiate() as Enemy
	enemy.position = position
	
	for playerNode in get_tree().get_nodes_in_group("player"):
		var player = playerNode as Player 
		enemy.players.append(player)
		
	self.level.add_child(enemy)	


func onPlayerDeath(player: Player) -> void:
	for enemyNode in get_tree().get_nodes_in_group("Enemies"):
		var enemy = enemyNode as Enemy
		enemy.players.erase( player )

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
	await get_tree().create_timer(1.0).timeout
	var spawnInfo = self.level.getHurryEnemy() 
	self.spawnEnemy( spawnInfo[0], spawnInfo[1] )

	
	
	
