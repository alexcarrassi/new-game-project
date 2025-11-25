class_name Teleporter extends Area2D


@export var Destination: Teleporter
@onready var Area: CollisionShape2D = $Area

var actors_destined: Array[Actor]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect( self.onAreaEntered )
	self.body_exited.connect( self.onAreaExited )
	
	self.monitorable = true
	self.monitoring = true
	
	pass # Replace with function body.

func onAreaEntered(body: Node2D) -> void:
	
	print("body entered")
	print(body.name)
	if(body is Actor):
		if( self.actors_destined.find( body) == -1 && self.Destination != null):
			self.Destination.actors_destined.append(body)
			body.position.y = self.Destination.position.y

func onAreaExited( body: Node2D) -> void:
	self.actors_destined.erase( body )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
