class_name WorldRoot extends Node

@onready var level: Level = $Level_01
@onready var UI: PlayerUI = $UI

func _ready() -> void:
	
	self.level.hurry.connect( self.onLevelHurry)
	self.UI.hurryShown.connect( self.endLevelHurry )


func onLevelHurry() -> void:
	self.UI.showHurry()
	get_tree().paused = true
	
func endLevelHurry() -> void:
	get_tree().paused = false	
	
	self.level.spawnHurryEneemy()
	
	
