class_name LevelDefinition extends Resource

@export var id: String
@export var scene: PackedScene
@export var next_by_exit: Dictionary[String, String]
@export var default_next: String
