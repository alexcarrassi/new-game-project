# Actorspawn.gd
# Spawns an actor at the node's position
# The defer_timer defers the moment of spawn
# When spawning, the actor tries to enter its SPAWNING state
# If a destination is given, the actor will be transported to the destination position
# Upon reaching the destination, the Actor is freed from its SPAWNING state and regular locomotion takes over
@tool
class_name ActorSpawn extends Marker2D


@export var direction: Vector2 = Vector2.LEFT:
	get:
		return direction
	set(value):
		direction = value
		if(Engine.is_editor_hint()):
			call_deferred("_update_icon")	
@export var spawn_defer_time: float = 0.1
@export var spawn_node: Node
@export var actorStayPut: bool = false
@export var disabled: bool:
	get: 
		return disabled 
	set(value):
		disabled = value
		if(Engine.is_editor_hint()):
			call_deferred("_update_icon")
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

signal actorSpawned()




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if( Engine.is_editor_hint()):
		self._update_icon()

		self.Icon.set_meta("_edit_lock_", true)

		# Mark the instance as "Editable Children" automatically.
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
	if(!self.disabled):
		
		self.defer_timer.start() 
	pass
	
#spawns the actor at their designated spawn point
func spawnActor() -> Tween:
	self.actor = Game.world.spawnEnemy(self.ActorScene, self.position, self.spawn_node )
	
	if(self.actorStayPut):
		self.actor.MAX_RUN_VELOCITY = 0
		if(self.actor is Enemy):
			self.actor.decision_timer.process_mode = Node.PROCESS_MODE_DISABLED
	
	
	if( self.actor.direction.x != self.direction.x):
		self.actor.flip()
	
	#if(self.destination.position == Vector2.ZERO):
		#self.actor.sm_status.state.finished.emit("ALIVE")	
		#return
	
	
	if(actor.sm_status.name != "SPAWNING"):
		actor.sm_status.state.finished.emit("SPAWNING")
	
	var transportSpeed = 70
	var transportDistance = actor.position.distance_to(self.destination.global_position)
	var transportTime = transportDistance / transportSpeed
	
	var transportTween = create_tween()
	transportTween.tween_property(actor, "position", self.destination.global_position, transportTime)
	transportTween.set_ease(Tween.EaseType.EASE_IN)
	
	transportTween.finished.connect( func() -> void:
		self.actorSpawned.emit()
	)
	
	return transportTween


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		queue_redraw()
	pass
	
	
	
func _draw() -> void:	
	if(Engine.is_editor_hint()) :
		var line_alpha = 1 if (!self.disabled) else 0.3
		draw_line(
			Vector2.ZERO, self.destination.position, Color(0.2, 0.8, 0.2, line_alpha), 1, true
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
			self.Icon.flip_h = self.direction.x > 0
			
			var c = Icon.modulate
			c.a = 0.7 if(!self.disabled) else 0.3
			self.Icon.modulate = c
		
		
		Actor.queue_free()	
				
