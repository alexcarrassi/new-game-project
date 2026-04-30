class_name ColorStateButton extends ButtonWithIcon

@export var colorIndex: int = 0
@onready var colorRect: ColorRect = $MarginContainer/ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(func() -> void:
			print('pressed')
			grab_click_focus()
	)
	pass # Replace with function body.

func setColor( color: Color) -> void:
	colorRect.color = color
	
func getColor() -> Color:
	return colorRect.color	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
