class_name PlayerHUD extends Control

var playerEntry: PlayerEntry
var playerStats_schema:PlayerStats_Schema = preload("res://actors/player/Stats/PlayerStats_Schema.tres")

@onready var label_Score = $Margin/Score
@onready var label_Time = $Margin/Time
@onready var label_Lives = $MarginContainer/Lives


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
	self.playerEntry.inventory.inventoryUpdated.connect(self.updateExtendInventory)
	
	for child: TextureRect in self.ExtendContainer.get_children():
		child.modulate = Color(1, 1, 1, 0)


	

	pass # Replace with function body.

func updateScore() -> void:
	self.label_Score.text = str(self.playerEntry.player.score)

func updateLives(actor: Actor) -> void:
	self.label_Lives.text = str(self.playerEntry.player.health)
	
func updateExtendInventory() -> void:
	for child: TextureRect in self.ExtendContainer.get_children():
		var item: ItemEntry = self.playerEntry.inventory.items.get(child.name)
		if(item && item.stack > 0) :
			child.visible = true 
			child.modulate = Color(1, 1, 1, 1)
		else:
			child.modulate = Color(1, 1, 1, 0)

		
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
