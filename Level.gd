class_name Level extends Node2D

@export var skelMunsta: PackedScene
@onready var p1_Start: Node2D = $p1_Start
@onready var bubbleDestination: Node2D = $Bubble_Destination
@onready var levelTimer: Timer = $Level_Timer
@onready var spawn_SkelMunsta: Node2D = $spawn_SkelMunsta

signal hurry()

# Span the player
# Connect the timer's timeout to the Hurry Up event
func _ready() -> void:
	self.levelTimer.timeout.connect( self.onHurryUp)

	pass # Replace with function body.

# Flash the Hurry message, pause during it. Spawn Skel-Monsta after a few seconds.
func onHurryUp() -> void:
	self.hurry.emit()


func getHurryEnemy() -> Array:
	return [self.skelMunsta, self.spawn_SkelMunsta.position]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print( self.levelTimer.time_left)
	pass
