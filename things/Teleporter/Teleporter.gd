class_name Teleporter extends Area2D


@export var Destination: Teleporter
@export var incrementStat: bool = false
@onready var Area: CollisionShape2D = $Area

var actors_destined: Array[CharacterBody2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect( self.onAreaEntered )
	self.body_exited.connect( self.onAreaExited )
	
	pass # Replace with function body.

#Handles teleportation to the Destination node 
func onAreaEntered(body: Node2D) -> void:
	
	if(body is CharacterBody2D):
		if( self.actors_destined.find( body) == -1 && self.Destination != null):
			self.teleportActor( body )
			
				
func teleportActor(actor: CharacterBody2D) -> void:
	self.Destination.actors_destined.append(actor)
	actor.position.y = self.Destination.position.y
	
	if(actor is Player):
		actor.statEvent.emit( PlayerStats.STATKEY_BOTTELEPORT, 1)

					
func onAreaExited( body: Node2D) -> void:
	self.actors_destined.erase( body )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
