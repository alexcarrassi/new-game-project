class_name ExtendBubbleSpawner extends BubbleSpawner

# The extend Bubbles queued to spawn
@export var bubbleQueue: Array[StringName] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func spawnBubble() -> Bubble:
	if(self.bubbleQueue.size() > 0):
		var toSpawn: StringName = self.bubbleQueue.pop_front()
		var newBubble: ExtendBubble = super.spawnBubble() as ExtendBubble
		newBubble.setType(toSpawn )
		
		return newBubble
		
		
	return null	
		
