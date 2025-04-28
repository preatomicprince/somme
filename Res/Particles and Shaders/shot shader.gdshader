shader_type canvas_item;

uniform vec4 color = vec4(0.0, 0.0, 0.0, 0.0);

uniform float red;
uniform float green;
uniform float blue;


void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.r = red;
	COLOR.b = blue;
	COLOR.g = green;
	//COLOR = vec4(0.0,0.0,0.0,0.0);
}