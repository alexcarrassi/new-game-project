class_name StartToJoin extends Control

@export var sprite: AtlasTexture
@export var flip_sprite: bool = false

@onready var _sprite: Sprite2D = $VBoxContainer/CenterContainer/Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var spriteAnimationPlayer: AnimationPlayer = $VBoxContainer/CenterContainer/SpriteAnimationPlayer

var spriteLoopCount: int = 0

func _ready() -> void:
	if(sprite):
		_sprite.texture = sprite
	
	_sprite.flip_h = flip_sprite
	animationPlayer.play("FlickerText")
	spriteAnimationPlayer.play("Idle")
	spriteAnimationPlayer.animation_finished.connect( onSpriteAnimationFinished)
	pass # Replace with function body.

func updateShaderMaterials(player_index: int) -> void:
			#setting the material's palette
	var mat: ShaderMaterial = _sprite.material.duplicate() as ShaderMaterial
	_sprite.material = mat
	mat.set_shader_parameter("color_0", PlayerCustomization.player_colors[player_index][0] )
	mat.set_shader_parameter("color_1", PlayerCustomization.player_colors[player_index][1] )
	mat.set_shader_parameter("color_2", PlayerCustomization.player_colors[player_index][2] )
	mat.set_shader_parameter("color_3", PlayerCustomization.player_colors[player_index][3] )

	
	pass
func onSpriteAnimationFinished(anim_name: String) -> void:
	match anim_name:
		"Idle":
			if(spriteLoopCount < 4):
				spriteAnimationPlayer.play("Idle")
				spriteLoopCount += 1
			else:
				spriteAnimationPlayer.play("Lookup")	
		"Lookup":
			spriteAnimationPlayer.play("Flutter")
		"Flutter":
			spriteAnimationPlayer.play("Idle")
			spriteLoopCount = 0
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
