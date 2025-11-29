@tool
class_name ActorSpawn extends Marker2D

@onready var Icon: Sprite2D = $Icon
@onready var defer_timer: Timer = $Defer_Timer

@export var ActorScene: PackedScene:
	get:
		return ActorScene
	set(value):
		ActorScene = value 
		if(Engine.is_editor_hint()) :
			call_deferred("_update_icon")

			
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if( Engine.is_editor_hint()):
		self._update_icon()
		var c = Icon.modulate
		c.a = 0.4
		self.Icon.modulate = c
	else:
		self.Icon.visible = false
		self.Icon.queue_free()
		
	self.defer_timer.timeout.connect( self.spawnActor )	 

# Run the defer_timer. After timeout, spawn the Actor
func deferSpawn() -> void:
	self.defer_timer.start() 
	
	pass
	
#spawns the actor at their designated spawn point
func spawnActor() -> void:
	
	Game.world.spawnEnemy(self.ActorScene, self.position )
	
#omoves the actor to teir starting location
#called in physics_process
func transportActor() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
	
	
func _update_icon():
	if(self.ActorScene == null) :
		#reset
		self.Icon.texture = null
		return 
	else:
		var Actor = ActorScene.instantiate()
		var actorSprite = Actor.get_node_or_null("Sprite2D")
		if(actorSprite):
			self.Icon.texture = actorSprite.texture
			self.Icon.region_rect = actorSprite.region_rect
		Actor.queue_free()	
				
