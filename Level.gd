class_name Level extends Node2D

@export var player: PackedScene
@export var skelMunsta: PackedScene
@onready var p1_Start: Node2D = $p1_Start
@onready var bubbleDestination: Node2D = $Bubble_Destination
@onready var levelTimer: Timer = $Level_Timer
@onready var spawn_SkelMunsta: Node2D = $spawn_SkelMunsta
@export var graphic_Hurry: Texture2D


# Span the player
# Connect the timer's timeout to the Hurry Up event
func _ready() -> void:
	
	await ready
	var playerNode = self.spawnPlayer()
	self.levelTimer.timeout.connect( self.onHurryUp)
	
	pass # Replace with function body.

func onPlayerDeath(player: Player) -> void:
	for enemyMode in get_tree().get_nodes_in_group("Enemies"):
		var enemy = enemyMode as Enemy
		enemy.players.erase(player)
		
		


# Flash the Hurry message, pause during it. Spawn Skel-Monsta after a few seconds.

func onHurryUp() -> void:
	print("Hurry")
	var skelMunsta = self.skelMunsta.instantiate() as Enemy
	skelMunsta.position = self.spawn_SkelMunsta.position

	self.add_child(self.graphic_Hurry)

	for playerNode in get_tree().get_nodes_in_group("player"):
		skelMunsta.players.append( playerNode  )
		
	self.add_child( skelMunsta) 

	
func spawnPlayer() -> Player:
	var playerNode = self.player.instantiate()
	
	self.add_child(playerNode)
	
	playerNode.position = self.p1_Start.position
	playerNode.Bubble_Destination = self.bubbleDestination

	playerNode.actorDeath.connect( self.onActorDeath)
	playerNode.actorHurt.connect( self.onActorHurt )

	for enemyNode in get_tree().get_nodes_in_group("Enemies"):
		var enemy = enemyNode as Enemy
		enemy.players.append(playerNode)
		
	return playerNode

func onActorHurt(actor: Actor) -> void:
	if(actor is Player) :
		self.levelTimer.start()
		
		
func onActorDeath(actor: Actor) -> void:
	if(actor is Player):
		onPlayerDeath(actor)
	actor.queue_free()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
