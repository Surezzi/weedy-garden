shader_type canvas_item;

uniform bool shader_enable = true;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 test_color = texture(TEXTURE, UV);
	if(shader_enable){
		COLOR = vec4(test_color.rgb, sin(TIME*5.0)*0.1);
	}
	else{
		COLOR = vec4(test_color.rgb, 0);
	}
}
