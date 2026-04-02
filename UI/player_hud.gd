class_name PlayerHUD extends Control

var playerEntry: PlayerEntry

@onready var label_Score = $Ingame/Margin/Score
@onready var label_Lives = $Ingame/MarginContainer/Lives

@onready var layer_ingame = $Ingame
@onready var startToJoin = $MarginContainer2/StartToJoin

@onready var ExtendContainer = $Ingame/Inventory/VBoxContainer
@onready var extend_E1 :TextureRect = $Ingame/Inventory/VBoxContainer/E1
@onready var extend_X :TextureRect = $Ingame/Inventory/VBoxContainer/X
@onready var extend_T :TextureRect = $Ingame/Inventory/VBoxContainer/T
@onready var extend_E2 :TextureRect = $Ingame/Inventory/VBoxContainer/E2
@onready var extend_N :TextureRect = $Ingame/Inventory/VBoxContainer/N
@onready var extend_D :TextureRect = $Ingame/Inventory/VBoxContainer/D
@export var font: Font
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	toggleIngame(false)
	
	pass # Replace with function body.


func setPlayerEntry( new_playerEntry: PlayerEntry):
	clean_connections()
	
	playerEntry = new_playerEntry
	if(playerEntry):
		var player = playerEntry.player
		player.scoreUpdated.connect( updateScore )
		player.actorHurt.connect( updateLives)
		player.actorDeath.connect( removePlayerEntry)
		player.actorLifeUp.connect( updateLives )
		label_Score.text = str(player.score)
		label_Lives.text = str(player.health)
		playerEntry.inventory.inventoryUpdated.connect(updateExtendInventory)
		
		for child: TextureRect in ExtendContainer.get_children():
			child.modulate = Color(1, 1, 1, 0)
		
		layout_direction = Control.LAYOUT_DIRECTION_LTR if playerEntry.player.player_index == 0 else Control.LAYOUT_DIRECTION_RTL
		toggleIngame(true)

	
func removePlayerEntry(actor: Actor) -> void: 
	clean_connections() 
	playerEntry = null
	
	toggleIngame(false)
		
func clean_connections() -> void:
	if(playerEntry ):
		if(playerEntry.player.scoreUpdated.is_connected(updateScore)):
			playerEntry.player.scoreUpdated.disconnect(updateScore)
			
		if(playerEntry.player.actorHurt.is_connected(updateLives)):
			playerEntry.player.actorHurt.disconnect(updateLives)	
		
		if(playerEntry.player.actorLifeUp.is_connected(updateLives)):
			playerEntry.player.actorLifeUp.disconnect(updateLives)	
			
		if(playerEntry.inventory.inventoryUpdated.is_connected(updateExtendInventory )):
			playerEntry.inventory.inventoryUpdated.disconnect(updateExtendInventory)	


func toggleIngame(on: bool) -> void: 
	layer_ingame.visible = on 
	startToJoin.visible = !on


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
