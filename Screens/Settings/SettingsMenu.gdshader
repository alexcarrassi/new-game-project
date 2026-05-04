shader_type canvas_item;

uniform sampler2D palette;
uniform float palette_size = 3.0;

uniform vec4 color_0;
uniform vec4 color_1;
uniform vec4 color_2;
uniform vec4 color_3;


void fragment() {
	vec4 index_tex = texture(TEXTURE, UV);
	float index_value = index_tex.r; 
	float index = clamp(floor(index_value * palette_size), 0, 3.0);
	
	vec4 final_color;
	
	if(index == 0.0){
		final_color = color_0;
	} else if (index == 1.0) {
		final_color = color_1;
	} else if (index == 2.0) {
		final_color = color_2;
	} else {
		final_color = color_3;			
	}
	
	final_color.a *= index_tex.a;
	COLOR = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
