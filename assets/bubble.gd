class_name Bubble extends Area2D

@export var hor_speed: float = 300.0
@export var vert_speed: float = 300.0

@onready var timer: Timer = $Timer
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var dir: Vector2 = Vector2.RIGHT


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.monitoring = true 
	self.monitorable = true 
	self.timer.one_shot = true 
	self.timer.wait_time = animationPlayer.get_animation("Pon").length
	self.timer.start()
	
	self.timer.timeout.connect( self.onEnd)
	self.animationPlayer.play("Pon")
	
	self.body_entered.connect( self.onBodyEntered )
	#connect("body_entered", Callable(self, "_on_body_entered"))
	#connect("area_entered", Callable(self, "_on_area_entered"))
	
	pass # Replace with function body.

func onBodyEntered(body: Node2D) -> void:
	if( body is Enemy) :
		print("Entered:!")
	pass
	
	
func onEnd() -> void:
	self.queue_free()
	

func _physics_process(delta: float) -> void:
	self.global_position.x += dir.x * self.hor_speed * delta 
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
