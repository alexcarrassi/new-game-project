class_name Level extends Node2D

@onready var p1_Start: Node2D = $p1_Start
@onready var bubbleDestination: Node2D = $Bubble_Destination
@onready var levelTimer: Timer = $Level_Timer
@onready var hurrySpawn: ActorSpawn = $Hurry_Enemy_spawn

signal hurry()

# Span the player
# Connect the timer's timeout to the Hurry Up event
func _ready() -> void:
	self.levelTimer.timeout.connect( self.onHurryUp)

	pass # Replace with function body.

# Flash the Hurry message, pause during it. Spawn Skel-Monsta after a few seconds.
func onHurryUp() -> void:
	self.hurry.emit()

func spawnHurryEnemy() -> void:
	if(self.hurrySpawn != null) :
		self.hurrySpawn.deferSpawn()

func getHurrySpawn() -> ActorSpawn:
	return self.hurrySpawn
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
