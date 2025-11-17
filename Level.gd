class_name Level extends Node2D

@export var player: PackedScene
@onready var p1_Start: Node2D = $p1_Start
@onready var bubbleDestination: Node2D = $Bubble_Destination

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = self.player.instantiate()
	self.add_child(player)
	player.position = self.p1_Start.position 
	player.Bubble_Destination = self.bubbleDestination
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
