class_name PlayerHUD extends Control

var playerEntry: PlayerEntry
@onready var label_Score = $Margin/Score
@onready var label_Time = $Margin/Time
@onready var label_Lives = $MarginContainer/Lives

@onready var Stats_List  = $Stats/VBoxContainer/Stats_list

@onready var ExtendContainer = $Inventory/VBoxContainer
@onready var extend_E1 :TextureRect = $Inventory/VBoxContainer/E1
@onready var extend_X :TextureRect = $Inventory/VBoxContainer/X
@onready var extend_T :TextureRect = $Inventory/VBoxContainer/T
@onready var extend_E2 :TextureRect = $Inventory/VBoxContainer/E2
@onready var extend_N :TextureRect = $Inventory/VBoxContainer/N
@onready var extend_D :TextureRect = $Inventory/VBoxContainer/D
@export var font: Font


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var player = self.playerEntry.player
	player.scoreUpdated.connect( self.updateScore )
	player.actorHurt.connect( self.updateLives)
	player.actorLifeUp.connect( self.updateLives )
	self.label_Score.text = str(player.score)
	self.label_Lives.text = str(player.health)
	player.Inventory.inventoryUpdated.connect(self.updateExtendInventory)
	
	for child: TextureRect in self.ExtendContainer.get_children():
		child.modulate = Color(1, 1, 1, 0)


	self.updateStats() 
	

	pass # Replace with function body.


func updateStats() -> void:
	var playerStats = self.playerEntry.stats
	for key in playerStats.stats:
		var nodePath := NodePath(String(key))
		var stat_label: Label = self.Stats_List.get_node_or_null( nodePath) 
		if(!stat_label):
			stat_label = Label.new() 
			stat_label.name = key 
			stat_label.add_theme_font_override("font", self.font)
			stat_label.add_theme_font_size_override("font_size", 8)

			self.Stats_List.add_child(stat_label)	
		var statText = "%s   %d" % [String(key).replace("_", " ").to_upper(), playerStats.stats[key] ]

		stat_label.text = statText
		
		

		
		print(stat_label.text)
		
		
func updateScore() -> void:
	self.label_Score.text = str(self.playerEntry.player.score)

func updateLives(actor: Actor) -> void:
	self.label_Lives.text = str(self.playerEntry.player.health)
	
func updateExtendInventory() -> void:
	for child: TextureRect in self.ExtendContainer.get_children():
		var item: ItemEntry = self.playerEntry.player.Inventory.inventory.get(child.name)
		if(item && item.stack > 0) :
			child.visible = true 
			child.modulate = Color(1, 1, 1, 1)
		else:
			child.modulate = Color(1, 1, 1, 0)

		
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
