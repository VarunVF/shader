#version 330 compatibility

uniform sampler2D lightmap;
uniform sampler2D gtexture;

uniform vec4 entityColor;

uniform int worldTime;

uniform float alphaTestRef = 0.1;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;
in vec3 normal;

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 lightmapData;
layout(location = 2) out vec4 encodedNormal;

const float MIN_MULTIPLY = 0.3;
const float MAX_MULTIPLY = 1.0;

#include "lib/util.glsl"


void main() {
	color = texture(gtexture, texcoord) * glcolor; // biome tint
	if (color.a < alphaTestRef) {
		discard;
	}

	lightmapData = vec4(lmcoord, 0.0, 1.0);
	encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);

	// shade blocks according to time of day
	color.rgb *= clamp(getTimeLerpFactor(worldTime), MIN_MULTIPLY, MAX_MULTIPLY);

	color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);
}