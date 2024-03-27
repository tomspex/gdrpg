shader_type canvas_item;

uniform vec3 color:source_color;
uniform float wipePercent = 0.0;
uniform bool toggleSide = false;

void fragment() {
	vec2 uv = UV;
	if(toggleSide) {
		uv.x *= -1.0;
	}
	COLOR = vec4(color, 0.0);
	if(uv.x > 1.0-wipePercent) {
		COLOR.a = 1.0;
	}
}