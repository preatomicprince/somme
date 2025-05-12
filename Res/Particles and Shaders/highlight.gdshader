shader_type canvas_item;

void fragment() {
    vec2 uv_offset = UV - vec2(0.5, 0.5);
    float distance = length(uv_offset);
	vec4 tex_color = texture(TEXTURE, UV);

    if (tex_color.a > 0.0) {
    if (distance > 0.45 && distance < 0.5) {
        COLOR = vec4(1.0, 1.0, 0.0, 1.0); // Yellow highlight
    } else {
        COLOR = texture(TEXTURE, UV);
    } }
	else {
        discard; // Ignore fully transparent pixels
    }

}
