@tool
class_name BubbleSpawer extends Node2D

@export var bubbleScene: PackedScene:
	get:
		return bubbleScene 
	set(value):
		bubbleScene = value
		if(Engine.is_editor_hint()):
			print("uh")
			call_deferred("update_icon")	
@export var disabled: bool:
	get:
		return disabled
	set(value):
		disabled = value
		if(Engine.is_editor_hint()):
			call_deferred("update_icon")

@onready var intervalTimer: Timer = $IntervalTimer
@onready var Icon: Sprite2D= $Icon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if(Engine.is_editor_hint()):
		self.update_icon()

		self.Icon.set_meta("_edit_lock", true)
		var edited_root = get_tree().edited_scene_root
		if(edited_root != null and edited_root != self) :
			edited_root.set_editable_instance(self, true)
		pass
	else:	
		self.Icon.visible = false
		self.Icon.queue_free()
		
		self.intervalTimer.timeout.connect( self.spawnBubble)




func update_icon() -> void:
	if(self.bubbleScene == null) :
		#reset
		self.Icon.texture = null
		return
	
	var bubble = self.bubbleScene.instantiate()
	var bubbleSprite : Sprite2D = bubble.get_node_or_null("Sprite2D")
	if(bubbleSprite):
		self.Icon.texture = bubbleSprite.texture
		self.Icon.region_rect = bubbleSprite.region_rect
		print(bubbleSprite.region_rect)
		var c = self.Icon.modulate
		c.a = 0.7 if (!self.disabled) else 0.3
		self.Icon.modulate = c
		
	bubble.queue_free()	


func spawnBubble() -> void:
	var newBubble = self.bubbleScene.instantiate()
	newBubble.position = self.position
	newBubble.destination = Game.world.level.bubbleDestination
	Game.world.level.add_child(newBubble)
	
	#self.intervalTimer.start( self.intervalTimer.wait_time )
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		queue_redraw()
	pass
	
	
