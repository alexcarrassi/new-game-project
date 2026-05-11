@tool
extends EditorPlugin 

var button 

func _enter_tree() ->void:
	button = Button.new()
	button.text = "Convert Sprite to Indexed"
	button.pressed.connect( onConversionButtonPress)
	
	add_control_to_container(CONTAINER_TOOLBAR, button)
	
	
func _exit_tree() -> void:
	remove_control_from_container(CONTAINER_TOOLBAR, button)
	button.queue_free()
	
func onConversionButtonPress() -> void:
	var selection = get_editor_interface().get_selection()
	var nodes = selection.get_selected_nodes()
	if(nodes.is_empty()):
		printerr("Nothing selected")
		return
	
	var node = nodes[0] 
	if node is TextureRect or node is Sprite2D:
		
		var texture: Texture = node.get_texture() 
		if(!texture):
			printerr("No texture found")
			return

		var img: Image = texture.get_image()
		if(!img):
			printerr("No image found on texture")
			return
			
			
		print(texture.resource_name)	
		var palette: Array[Color] = extract_palette(img)
		print("Palette contains %d color(s)" %  palette.size())	
		
		var color_map : Dictionary[int, Color] = {}
		for i in palette.size():
			color_map[i] = palette[i]
		
		var indexed_img: Image = convert_to_index(img, color_map)
		var path = texture.resource_path.get_basename() + "indexed.png"
		indexed_img.save_png(path)
		
		print("saved texture to: %s" % [path])
		
		pass
	
	pass
	
func extract_palette(img: Image) -> Array[Color]:
	
	var colors: Array[Color]= []

	for y in img.get_height():
		for x in img.get_width():
			var c: Color = img.get_pixel(x,y)
			if c.a < 0.5:
				continue
			
			var found = false 
			for existing in colors:
				if c.is_equal_approx(existing):
					found = true		
					break
	
			if not found:
				colors.append(c)	
	
	print(colors)
	return colors
	
func convert_to_index(src: Image, color_map: Dictionary[int,Color]) -> Image:
	var dst: Image = Image.create(src.get_width(), src.get_height(), false, Image.FORMAT_RGBA8)
	
	for y in src.get_height():
		for x in src.get_width():
			var c: Color = src.get_pixel(x,y)
			
			if c.a < 0.5:
				dst.set_pixel(x,y, Color(0, 0, 0, 0))
				continue
			
			var index = find_color_index(c, color_map)	
			
			var encoded: float = float(index) / 255.0
			dst.set_pixel(x, y, Color(encoded, 0, 0, 1.0))

	
	return dst
	
func find_color_index(color: Color, color_map: Dictionary[int, Color])-> int:
		
	for i in color_map.keys():
		var target_color = color_map[i] 
		if(color.is_equal_approx(color_map[i])):
			return i	
		
	return -1
		
