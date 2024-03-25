shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 newUV = UV;
	newUV.x = sin(newUV.y);
	vec2 disUV;
	disUV.x = UV.x * newUV.y;
	
	COLOR = vec4(0, disUV.x, 0, 1);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
