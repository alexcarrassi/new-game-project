class_name Level extends Node2D

@export var player: PackedScene
@onready var p1_Start: Node2D = $p1_Start
@onready var bubbleDestination: Node2D = $Bubble_Destination

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await ready
	var playerNode = self.spawnPlayer()
	
	
	pass # Replace with function body.

func onPlayerDeath(player: Player) -> void:
	for enemyMode in get_tree().get_nodes_in_group("Enemies"):
		var enemy = enemyMode as Enemy
		enemy.players.erase(player)
		
		

func spawnPlayer() -> Player:
	var playerNode = self.player.instantiate()
	
	self.add_child(playerNode)
	
	playerNode.position = self.p1_Start.position
	playerNode.Bubble_Destination = self.bubbleDestination

	playerNode.actorDeath.connect( self.onActorDeath)

	for enemyNode in get_tree().get_nodes_in_group("Enemies"):
		var enemy = enemyNode as Enemy
		enemy.players.append(playerNode)
		
	return playerNode

func onActorDeath(actor: Actor) -> void:
	if(actor is Player) :
		onPlayerDeath(actor)
		
	actor.queue_free()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
