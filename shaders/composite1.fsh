#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform mat4 gbufferProjectionInverse;

uniform float far;			// player render distance
uniform vec3 fogColor;		// vanilla fog color

in vec2 texcoord;

#define DRAW_FOG
#define FOG_DENSITY 5.0 // [1.0 2.0 3.0 4.0 5.0]


#include "lib/util.glsl"

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;


// Exponential falloff based on Beer-Lambert Law
// Expect dist in [0.0, 1.0]
float getFogFactor(float dist) {
	return exp(-FOG_DENSITY * (1.0 - dist));
}

void main() {
	color = texture(colortex0, texcoord);

	float depth = texture(depthtex0, texcoord).r;
	if (depth == 1.0) {
		return;
	}

	vec3 NDCPos = vec3(texcoord.xy, depth) * 2.0 - 1.0;
	vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);

#ifdef DRAW_FOG
	float fogFactor = getFogFactor(length(viewPos)/far);
	color.rgb = mix(color.rgb, pow(fogColor, vec3(2.2)), clamp(fogFactor, 0.0, 1.0));
#endif
}
