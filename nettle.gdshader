shader_type canvas_item;

void vertex() {
	float wave = sin(TIME * 2.0);
	
	VERTEX.x += wave * (1.0 - UV.y);
}

void fragment() {
}
