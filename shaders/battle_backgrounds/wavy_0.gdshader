shader_type sky;

uniform sampler2D sprite_back : filter_nearest;
uniform sampler2D sprite_front : filter_nearest;
uniform float waviness_back = 4.0;
uniform float waviness_front = 6.0;
uniform float frequency_back = 3.0;
uniform float frequency_front = 1.5;
uniform float amplitude_back = 0.2;
uniform float amplitude_front = 0.1;
uniform float contrast = 1.0;
uniform float brightness = 1.0;

void sky() {
	float wave_back = EYEDIR.x + amplitude_back*sin(EYEDIR.y*waviness_back+TIME*frequency_back);
	float wave_front = EYEDIR.x + amplitude_front*cos(EYEDIR.y*waviness_front+TIME*frequency_front);
	COLOR.rgb = texture(sprite_back, -vec2(wave_back, EYEDIR.y)).rgb/2.0;
	COLOR.rgb += texture(sprite_front, -vec2(wave_front, EYEDIR.y)).rgb/2.0;
	COLOR.rgb *= contrast;
	COLOR.rgb += brightness;
}