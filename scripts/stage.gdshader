shader_type canvas_item;

uniform float brightness: hint_range(-1.0, 1.0, 0.01) = 0.0;
uniform float saturation: hint_range(-10.0, 10.0, 0.01) = 0.5;

mat4 brightness_matrix(float b) {
	return mat4(
		vec4(1, 0, 0, 0),
		vec4(0, 1, 0, 0),
		vec4(0, 0, 1, 0),
		vec4(b, b, b, 1)
	);
}
mat4 saturation_matrix(float s) {
	vec3 luminance = vec3(0.3086, 0.6094, 0.0820);
	float sr = (1.0 - s) * luminance.r;
	float sg = (1.0 - s) * luminance.g;
	float sb = (1.0 - s) * luminance.b;
	return mat4(
		vec4(sr + s, sr, sr, 0),
		vec4(sg, sg + s, sg, 0),
		vec4(sb, sb, sb + s, 0),
		vec4(0, 0, 0, 1)
	);
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	mat4 matrix = brightness_matrix(brightness) * saturation_matrix(saturation);
	COLOR = matrix * color;
}
