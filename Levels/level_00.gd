class_name Level_00 extends Level

#variables for the circular motion around the ransition slots
var angle: float = 0
var speed: float = 3.0
var radius: int = 20
var offset: Vector2 = Vector2(0, 20)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.

func start() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	angle += speed * delta

	for index :int in Game.playerEntries:
		var playerEntry = Game.getPlayerEntry(index)
		if playerEntry != null and playerEntry.player != null:
				
			var transitionSlotPos = Game.world.getTransitionSlot(index).global_position
			playerEntry.player.global_position = transitionSlotPos + Vector2(cos(angle), sin(angle)) * radius + offset
			
			
			
	pass
