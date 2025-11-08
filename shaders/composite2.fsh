#version 330 compatibility

uniform sampler2D colortex0;

in vec2 texcoord;

#define CONTRAST 1.0 // [0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3]

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	color = texture(colortex0, texcoord);
	
	color.rgb -= vec3(0.5);
	color.rgb *= CONTRAST;
	color.rgb += vec3(0.5);
	clamp(color, 0.0, 1.0);
}