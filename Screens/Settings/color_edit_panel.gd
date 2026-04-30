class_name ColorEditPanel extends PopupPanel

var player_index: int = 0

@onready var btn_reset: Button = $MarginContainer/VBoxContainer/HBoxContainer/btn_reset
@onready var btn_save: Button = $MarginContainer/VBoxContainer/HBoxContainer/btn_save

@onready var btn_color_0: ColorStateButton = $MarginContainer/VBoxContainer/ColorContainer/ColorStateButton0
@onready var btn_color_1: ColorStateButton = $MarginContainer/VBoxContainer/ColorContainer/ColorStateButton1
@onready var btn_color_2: ColorStateButton = $MarginContainer/VBoxContainer/ColorContainer/ColorStateButton2
@onready var btn_color_3: ColorStateButton = $MarginContainer/VBoxContainer/ColorContainer/ColorStateButton3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('ready')

	about_to_popup.connect(intialize_self)
	btn_reset.pressed.connect(reset_colors)
	btn_save.pressed.connect(save_colors)


	pass # Replace with function body.

	
func intialize_self() -> void:
	print("Player index: %d" %[player_index])
	btn_color_0.colorRect.color = PlayerCustomization.player_colors[player_index][0]
	btn_color_1.colorRect.color = PlayerCustomization.player_colors[player_index][1]
	btn_color_2.colorRect.color = PlayerCustomization.player_colors[player_index][2]
	btn_color_3.colorRect.color = PlayerCustomization.player_colors[player_index][3]
	pass
	
	
func save_colors() -> void:
	PlayerCustomization.player_colors[player_index][0] = btn_color_0.colorRect.color
	PlayerCustomization.player_colors[player_index][1] = btn_color_1.colorRect.color
	PlayerCustomization.player_colors[player_index][2] = btn_color_2.colorRect.color
	PlayerCustomization.player_colors[player_index][3] = btn_color_3.colorRect.color
	
	hide() 
	pass
	
func reset_colors() -> void:
	btn_color_0.colorRect.color = PlayerCustomization.player_colors[player_index][0]
	btn_color_1.colorRect.color = PlayerCustomization.player_colors[player_index][1]
	btn_color_2.colorRect.color = PlayerCustomization.player_colors[player_index][2]
	btn_color_3.colorRect.color = PlayerCustomization.player_colors[player_index][3]
	pass

	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
