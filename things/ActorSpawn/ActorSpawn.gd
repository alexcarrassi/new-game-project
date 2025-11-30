# Actorspawn.gd
# Spawns an actor at the node's position
# The defer_timer defers the moment of spawn
# When spawning, the actor tries to enter its SPAWNING state
# If a destination is given, the actor will be transported to the destination position
# Upon reaching the destination, the Actor is freed from its SPAWNING state and regular locomotion takes over
@tool
class_name ActorSpawn extends Marker2D


@export var spawn_defer_time: float = 0.1

@onready var Icon: Sprite2D = $Icon
@onready var defer_timer: Timer = $Defer_Timer
@onready var destination: Marker2D = $Destination


var is_spawning: bool = false
@export var ActorScene: PackedScene:
	get:
		return ActorScene
	set(value):
		ActorScene = value 
		if(Engine.is_editor_hint()) :
			call_deferred("_update_icon")

			
			
var actor: Actor			




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if( Engine.is_editor_hint()):
		self._update_icon()
		var c = Icon.modulate
		c.a = 0.4
		self.Icon.modulate = c
		
		# tMark the instance as "Editable Children" automatically.
		var edited_root := get_tree().edited_scene_root
		if edited_root != null and edited_root != self:
			edited_root.set_editable_instance(self, true)
		
		
	else:
		self.Icon.visible = false
		self.Icon.queue_free()
			
	self.defer_timer.wait_time = self.spawn_defer_time	
	self.defer_timer.timeout.connect( self.spawnActor )	 

# Run the defer_timer. After timeout, spawn the Actor
func deferSpawn() -> void:
	self.defer_timer.start() 
	pass
	
#spawns the actor at their designated spawn point
func spawnActor() -> void:
	var actor = Game.world.spawnEnemy(self.ActorScene, self.position )
	if(self.destination.position == Vector2.ZERO):
		actor.sm_status.state.finished.emit("ALIVE")	
		return
	
	
	if(actor.sm_status.name != "SPAWNING"):
		actor.sm_status.state.finished.emit("SPAWNING")
	
	var transportTween = create_tween()
	transportTween.tween_property(actor, "position", self.destination.global_position, 1)
	transportTween.set_ease(Tween.EaseType.EASE_IN)
	
	transportTween.finished.connect( func() -> void:
		actor.sm_status.state.finished.emit("ALIVE")	
	)
	
#omoves the actor to their starting location
#called in physics_process
func transportActor() -> void:
	pass






# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		queue_redraw()
	pass
	
	
	
func _draw() -> void:	
	if(Engine.is_editor_hint()) :
		draw_line(
			Vector2.ZERO, self.destination.position, Color(0.2, 0.8, 0.2), 1, true
		)

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
				
