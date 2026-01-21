class_name Item extends Resource

@export var id: StringName
@export var display_name: String
@export var ingameIcon: Texture2D 
@export var inventoryIcon: Texture2D
@export var ItemEffects: Array[ItemEffect] = []
@export var consume: bool 
@export var stackable: bool = false
@export var maxStack: int = 1
