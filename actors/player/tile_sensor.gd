class_name TileSensor extends Node2D

@onready var sensor_front: ShapeCast2D = $sensor_front
@onready var sensor_top : ShapeCast2D = $sensor_top
@onready var sensor_full : ShapeCast2D = $sensor_full
@export var should_ignore_platforms: bool = true

@export var tileState: TileState = TileState.NONE


enum TileState {
	NONE,
	FULL_PASS,
	FRONT_PROC,
	FRONT_TOP_PROC
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	

func setTileState(tileState: TileState) -> void:
	var parent = get_parent()
	match tileState:
		TileState.FULL_PASS:
			#parent.set_collision_mask_value(1, false)
			parent.set_collision_mask_value(13, false)

		TileState.FRONT_PROC:
			#parent.set_collision_mask_value(1, true)
			pass
		TileState.FRONT_TOP_PROC: 
			parent.set_collision_mask_value(13, false)
		TileState.NONE:
			#parent.set_collision_mask_value(1, true)
			parent.set_collision_mask_value(13, true)

	#parent.set_collision_mask_value(1, false)
	self.tileState = tileState
	pass

# Sensor front gets priority.
# If sensor front is colliding, and we aren't a;ready ignoring tiles, then we do nothing

func _physics_process(delta: float) -> void:
	
	sensor_front.force_shapecast_update()
	sensor_top.force_shapecast_update()
	sensor_top.force_update_transform()
	sensor_front.force_update_transform()
	var parent: Actor = get_parent() as Actor
	scale.x = 1 if (parent.sprite2D.flip_h) else -1
	
	if(parent.velocity.y < 0.0):
		if(tileState == TileState.NONE):
			
			if(sensor_front.is_colliding()):
				setTileState(TileState.FRONT_PROC)
				pass
			elif(sensor_top.is_colliding()):
				#ignore.
				setTileState(TileState.FULL_PASS)
				pass	
		elif(tileState == TileState.FRONT_PROC):
			if(sensor_top.is_colliding()):
				setTileState(TileState.FRONT_TOP_PROC)
						
	elif(parent.velocity.y > 0.0):
		#falling down tries to reset the state to not ignoring. But only if we're not colliding anymore.
		if(tileState != TileState.NONE):
			if(!sensor_full.is_colliding()):
				setTileState(TileState.NONE)
	
	
	
	pass
	
	
