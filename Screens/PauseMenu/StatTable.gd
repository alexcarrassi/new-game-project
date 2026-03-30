class_name PlayerStatTable extends MarginContainer

var playerEntry: PlayerEntry
var playerStats_schema:PlayerStats_Schema = preload("res://actors/player/Stats/PlayerStats_Schema.tres")

@export var font: Font

@onready var stats_list = $VBoxContainer/Stats_list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# The debug panelContainer should give this class its player in the near future
	if(playerEntry):
		playerEntry.stats.statsUpdated.connect( self.updateStats)
		updateStats()
	pass # Replace with function body.

func updateStats() -> void:
	for statDef: PlayerStatDef in  playerStats_schema.stats:
			var nodePath = NodePath(String(statDef.key))
			var stat_label: Label = stats_list.get_node_or_null( nodePath )
			if(!stat_label):
				stat_label = Label.new() 
				stat_label.name = statDef.key 
				stats_list.add_child( stat_label )
				stat_label.add_theme_font_size_override("font_size", 8)
				stat_label.autowrap_mode = TextServer.AUTOWRAP_WORD
			var statValue = playerEntry.stats.getStat( statDef.key)	
			stat_label.text	= "%s %d" % [String(statDef.name).replace("_", " ").to_upper() , statValue] 
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
