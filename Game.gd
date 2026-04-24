#Game (Autoload)
class_name auGame extends Node


var root: WorldWrapper
var gameWorldScene :PackedScene = load("res://GameWorld.tscn")
var mainMenuScene :PackedScene = load("res://Screens/MainMenu/MainMenu.tscn")
var titleScene :PackedScene    = load("res://Screens/Title/TitleScreen.tscn")
var pauseMenuScene :PackedScene = load("res://Screens/PauseMenu/PauseMenu.tscn")
var settingsMenuScene :PackedScene = load("res://Screens/Settings/SettingsMenu.tscn")


var world: GameWorld 
var playerEntries : Dictionary[int, PlayerEntry]
var currentLevel: int = 0
var difficulty = 1
var is_frameStepping = false

signal playerRegistered(playerEntry: PlayerEntry) 

func _ready() -> void:

	self.process_mode = Node.PROCESS_MODE_ALWAYS
	Settings.load_settings()
	
func register_root( root_node: WorldWrapper) -> void:
	root = root_node	
func register_player(index: int, player: Player) -> PlayerEntry:
	var playerEntry = PlayerEntry.new()
	#var playerStats = world.playerStats_Schema.duplicate(true)
	var inventory = InventoryController.new(player)
	
	playerEntry.player = player
	playerEntry.stats = PlayerStats.new() 
	playerEntry.stats.createStatsFromSchema( preload("res://actors/player/Stats/PlayerStats_Schema.tres"))
	player.statEvent.connect(playerEntry.stats.onStatEvent)
	playerEntry.id = index
	playerEntry.inventory = inventory
	self.playerEntries[index] = playerEntry
	

	playerRegistered.emit(playerEntry)
	return playerEntry

func deregister_player(index: int) -> Dictionary[int, PlayerEntry]:
	self.playerEntries.erase(index)  
	return self.playerEntries



func getLevelById( id: String) -> LevelDefinition:
	return LevelDatabase.getLevelDefinition(id)

func register_currentLevel( level_index: int) -> int:
	self.currentLevel = level_index
	return self.currentLevel
	
func getNextLevel_id() -> String:
	if(!self.world.level):
		return ""
	
	var nextLevel_id = self.world.level.definition.default_next
		
	
			
	return nextLevel_id
		
func _input(event: InputEvent) -> void:
	if(world) :
		ingame_input(event)


func ingame_input(event: InputEvent) -> void:
	if ( event.is_action_pressed("ui_start") ):
		# If Player 1 is already alive, then this is the Pause button.
		if(getPlayerEntry(0)) :
				# pause 
			var tree = get_tree()
			if(!tree.paused):
				pause_game()
			else:
				resume_game()
		else:
			# Spawn player 
			var player = world.createPlayer(0)
			player.sm_status.state.finished.emit("ALIVE")
			world.spawnPlayer(player)		

		pass
	elif(event.is_action_pressed("ui_accept_p2")):
	# If Player 2 is already alive, then this is the Pause button.
		if(getPlayerEntry(1)) :
				# pause 
			var tree = get_tree()
			if(!tree.paused):
				pause_game()
			else:
				resume_game()
		else:
			# Spawn player 
			var player = world.createPlayer(1)
			player.sm_status.state.finished.emit("ALIVE")
			world.spawnPlayer(player)		
					
	elif(event.is_action_pressed("debug_LevelStart")):
		self.world.level.cleanup()
		self.world.level.levelTimer.start( self.world.level.levelTimer.wait_time)
		self.world.startLevel( self.world.level )
		pass
	elif(event.is_action_pressed("debug_NextLevel")):
		if(!self.world.is_transitioning_Levels):
			self.world.levelTransition()
	elif(event.is_action_pressed("debug_GodMode")):
		for key: int in self.playerEntries:
			var player : Player = self.playerEntries[key].player
					
			player.hurtbox.monitorable = !player.hurtbox.monitorable 
			player.hurtbox.monitoring = !player.hurtbox.monitoring
			player.sprite2D.modulate = Color(100, 100, 0, 0.5) if !player.hurtbox.monitorable else Color(1,1,1,1)
	elif(event.is_action_pressed("debug_advanceFrame")):
		var tree = get_tree()
		if(tree.paused && !self.is_frameStepping):
			
			self.is_frameStepping = true
			tree.paused = false
			await get_tree().physics_frame
			await get_tree().process_frame

			tree.paused = true
			
			self.is_frameStepping = false	
	elif(event.is_action_pressed("debug_LevelWarper")):
		var tree = get_tree()
		
		var dialog = tree.current_scene.get_node_or_null("LevelWarp")
		if(!dialog):
			dialog = AcceptDialog.new()
			dialog.name = "LevelWarp"
			dialog.title = "Warp to level"
			dialog.dialog_text = "Enter level id: "
			dialog.exclusive = false
			dialog.process_mode = Node.PROCESS_MODE_ALWAYS
			tree.current_scene.add_child( dialog )
	
			var levelInput = LineEdit.new() 
			levelInput.process_mode = Node.PROCESS_MODE_ALWAYS
			levelInput.focus_mode = Control.FOCUS_ALL
			dialog.add_child(levelInput)
			levelInput.text_submitted.connect( func() -> void:
				var text = levelInput.text
				self.levelWarp(text)
			)
		
			dialog.confirmed.connect( func() -> void:
				var text = levelInput.text
				self.levelWarp(text)
			)
			dialog.visibility_changed.connect( func() -> void:
				tree.paused = false
				if(dialog.visible):
					levelInput.grab_focus()
			)
			
			
		
		if(!self.world.is_transitioning_Levels):
			dialog.popup_centered()
			tree.paused = true
	elif(event.is_action_pressed("debug_KillAll")):
		self.world.level.cleanEnemies()
	elif(event.is_action_pressed("debug_queueRewards")):
		self.world.queue_items_for_spawn()	
		
func levelWarp( levelId: String) -> void:
	
	if(self.world.is_transitioning_Levels):
		return
		
	#validate the levelID
	if( ! LevelDatabase.getLevelDefinition(levelId) ):
		printerr("Level not found: %s" %[levelId] )
		return
		
	self.world.levelTransition({
		"nextLevel_id": levelId
	})
			
func register_gameWorld(node:GameWorld) -> GameWorld:
	self.world = node 
	return self.world	


func getPlayerEntry(index: int) -> PlayerEntry: 
	return self.playerEntries.get(index, null)

	
func pause_game() -> void:
	var tree = get_tree()

	var pauseMenu = pauseMenuScene.instantiate()
	root.screenlayer.add_child(pauseMenu)
	tree.paused = true

	print(SaveGame.serialize())
	SaveGame.saveFile()
	pass
	
func resume_game() -> void:

	for child: Control in root.screenlayer.	get_children():
		child.free()
		
	var tree = get_tree()
	tree.paused = false

	pass

func start_new_game(params: Dictionary) -> void: 
	world = gameWorldScene.instantiate() as GameWorld 
	
	for child in root.gameViewPort.get_children():
		child.free() 
		
	root.gameViewPort.add_child(world) 
	
	for child in root.screenlayer.get_children():
		child.free()
		
	world.initialize(params)	
		
func continue_game() -> void:
	print("continue")	

	var saveData = SaveGame.loadFile()
	if(saveData) :
		Game.difficulty = saveData["gamestate"]["difficulty"]
		Game.currentLevel = saveData["gamestate"]["levelid"]
		Game.start_new_game(saveData)
	else :
		Game.start_new_game({})
			
func exit_to_main_menu() -> void:
	
	clean_layers()
		
	var mainMenu = mainMenuScene.instantiate() as MainMenu 
	root.screenlayer.add_child(mainMenu)

func clean_layers() -> void: 
	get_tree().paused = false
	
	for child in root.gameViewPort.get_children():
		child.queue_free() 
	
	for child in root.screenlayer.get_children():
		child.queue_free()
		
		
	for i: int in playerEntries.keys():
		deregister_player(i)
		
	call_deferred("finalize_cleanup")	
		
func finalize_world_cleanup() -> void:
	world = null
	
func open_settings_menu() -> void:
	clean_layers()

	var settingsMenu = settingsMenuScene.instantiate() as SettingsScreen
	root.screenlayer.add_child(settingsMenu)		

func exit_to_title() -> void: 
	clean_layers()
		
	var titleScene = titleScene.instantiate() as TitleScreen
	root.screenlayer.add_child( titleScene ) 


func exit() -> void:
	get_tree().quit()
