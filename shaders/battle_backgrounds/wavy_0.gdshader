shader_type canvas_item;

uniform float opacity = 1.0;
uniform float waviness = 4.0;
uniform float frequency = 3.0;
uniform float amplitude = 0.1;

void fragment() {
	float wave = UV.x + amplitude*sin(UV.y*waviness+TIME*frequency);
	COLOR = texture(TEXTURE, vec2(wave, UV.y));
	COLOR.a *= opacity;
}