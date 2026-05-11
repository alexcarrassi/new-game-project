shader_type canvas_item;

uniform vec4 color_0 : source_color;
uniform vec4 color_1 : source_color;
uniform vec4 color_2 : source_color;
uniform vec4 color_3 : source_color;

void fragment() {
	vec4 index_tex = texture(TEXTURE, UV);

	int index = int(round(index_tex.r * 255.0));

	vec4 final_color;

	if (index == 0) {
		final_color = color_0;
	} else if (index == 1) {
		final_color = color_1;
	} else if (index == 2) {
		final_color = color_2;
	} else {
		final_color = color_3;
	}

	final_color.a = index_tex.a;
	COLOR = final_color;
}