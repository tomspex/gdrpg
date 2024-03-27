shader_type canvas_item;

uniform vec3 color:source_color;
uniform float margin_value = 0.0;

void fragment() {
	COLOR = vec4(color, 0.0);
	if(UV.y<margin_value || UV.y>1.0-margin_value) {
		COLOR.a = 1.0;
	}
}
