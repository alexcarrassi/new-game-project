class_name PlayerHUD extends Control

var player: Player
@onready var label_Score = $Margin/Score
@onready var label_Time = $Margin/Time
@onready var label_Lives = $MarginContainer/Lives

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.player.scoreUpdated.connect( self.updateScore )
	self.player.actorHurt.connect( self.updateLives)
	self.label_Score.text = str(player.score)
	self.label_Lives.text = str(player.health)
	pass # Replace with function body.


func updateScore() -> void:
	self.label_Score.text = str(self.player.score)

func updateLives(actor: Actor) -> void:
	self.label_Lives.text = str(self.player.health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
