class_name ColorEditPanel extends PopupPanel

var player_index: int = 0

@onready var btn_reset: Button = $MarginContainer/VBoxContainer/HBoxContainer/btn_reset
@onready var btn_save: Button = $MarginContainer/VBoxContainer/HBoxContainer/btn_save

@onready var colorBtns : Array[ColorStateButton] = [
	$MarginContainer/VBoxContainer/ColorContainer/ColorStateButton0,
	$MarginContainer/VBoxContainer/ColorContainer/ColorStateButton1,
	$MarginContainer/VBoxContainer/ColorContainer/ColorStateButton2,
	$MarginContainer/VBoxContainer/ColorContainer/ColorStateButton3
]


@onready var btn_color_0: ColorStateButton = $MarginContainer/VBoxContainer/ColorContainer/ColorStateButton0
@onready var btn_color_1: ColorStateButton = $MarginContainer/VBoxContainer/ColorContainer/ColorStateButton1
@onready var btn_color_2: ColorStateButton = $MarginContainer/VBoxContainer/ColorContainer/ColorStateButton2
@onready var btn_color_3: ColorStateButton = $MarginContainer/VBoxContainer/ColorContainer/ColorStateButton3

@onready var colorPicker: ColorPicker = $MarginContainer/VBoxContainer/ColorPicker

var btn_colorActive: ColorStateButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('ready')

	about_to_popup.connect(intialize_self)
	btn_reset.pressed.connect(reset_colors)
	btn_save.pressed.connect(save_colors)

	colorPicker.color_changed.connect(setColor)


	for btn: ColorStateButton in colorBtns:
		btn.pressed.connect( func() -> void:
			btn_colorActive = btn
		)
	pass # Replace with function body.

	
func setColor(color: Color) -> void:
	if(btn_colorActive):	
		btn_colorActive.setColor(color)
	
		
func intialize_self() -> void:
	print("Player index: %d" %[player_index])
	btn_colorActive = colorBtns[0]
	for i in range(colorBtns.size()):
		print(PlayerCustomization.player_colors[player_index][i])
		colorBtns[i].setColor( PlayerCustomization.player_colors[player_index][i] )
		
		pass
	
	
func save_colors() -> void:
	for i in range(colorBtns.size()):
		PlayerCustomization.player_colors[player_index][i] = colorBtns[i].colorRect.color
	hide() 
	
func reset_colors() -> void:
	for i in range(colorBtns.size()):
		colorBtns[i].colorRect.color = PlayerCustomization.player_colors[player_index][i]

	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
