class_name State_Attack extends State

@export var bubble: PackedScene
@export var default_bubble_cooldown = 0.6
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
	
	
func enter(prev_state: State, data: Dictionary ):
	
	var player: Player = body as Player
	#Register stat
	var playerEntry: PlayerEntry = Game.getPlayerEntry(self.body.player_index) 
	playerEntry.player.statEvent.emit(PlayerStats.STATKEY_BUBBLES_BLOWN, 1)
	
	var bubble: PlayerBubble = bubble.instantiate()
	var body_dir = -1 if( self.body.sprite2D.flip_h) else 1
	bubble.dir = Vector2(body_dir  , 0)
	bubble.global_position = Vector2(self.body.position.x, self.body.position.y - self.body.sprite2D.get_rect().size.y/2 )
	bubble.ownerPlayer = player

	#Add the bubble range extensions
	var extension = playerEntry.stats.getStat(&"bubble_range") 
	bubble.shoot_range += extension
	
	Game.world.level.add_child(bubble)
	get_tree().current_scene.add_child(bubble)
	if(player.bubbleSpriteSheet):
		bubble.sprite.texture = player.bubbleSpriteSheet
	
	
	var cooldown_mult = playerEntry.stats.getStat(PlayerStats.STATKEY_BUBBLE_RATE_MULT)
	var cooldown = self.default_bubble_cooldown / cooldown_mult

	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = cooldown  #We are going to subtrat the Shot speed powerup here
	self.timer.timeout.connect(self.endAttack)
	self.add_child(self.timer)

	self.timer.start()
	player.has_shot_bubble.emit()



	
func exit() -> void:
	self.timer.stop()
	self.timer.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func endAttack() -> void:
	self.finished.emit("NONE")
