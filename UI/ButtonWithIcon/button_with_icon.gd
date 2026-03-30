class_name ButtonWithIcon extends Button

@export var cursor: AtlasTexture = load("res://assets/misc/cursor.tres")
@export var cursorSlot: AtlasTexture  = load("res://assets/misc/cursor_slot.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	focus_entered.connect(func() -> void: set_button_icon(cursor))
	focus_exited.connect( func() -> void: set_button_icon(cursorSlot))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
