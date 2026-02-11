class_name State_Attack extends State

@export var bubble: PackedScene
var timer: Timer


func _ready() -> void:
	pass
	
func enterEffects() -> Array:
	return [
		{
			"oneshot": { 
				"animation" : "attack",
				"prio"		: AnimationController.StatePriority.ACT,
			}
		}
	]	
	
	
func enter(prev_state_path: String, data: Dictionary ):
	
	self.body.buffer_times['attack'] = 0
	var bubble: PlayerBubble = bubble.instantiate()
	bubble.destination =  Game.world.level.bubbleDestination  
	var body_dir = -1 if( self.body.sprite2D.flip_h) else 1
	bubble.dir = Vector2(body_dir  , 0)
	bubble.global_position = Vector2(self.body.position.x, self.body.position.y - self.body.sprite2D.get_rect().size.y/2 )
	Game.world.level.add_child(bubble)
	get_tree().current_scene.add_child(bubble)
	
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = 0.3
	self.timer.timeout.connect(self.endAttack)
	self.add_child(self.timer)

	self.timer.start()

	#Register stat
	var playerEntry: PlayerEntry = Game.getPlayerEntry(self.body.player_index) 
	var statValue = playerEntry.stats.getStat(PlayerStats.STATKEY_BUBBLES_BLOWN)
	playerEntry.stats.setStat(PlayerStats.STATKEY_BUBBLES_BLOWN, statValue + 1)

	
func exit() -> void:
	self.timer.stop()
	self.timer.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func endAttack() -> void:
	self.finished.emit("NONE")
