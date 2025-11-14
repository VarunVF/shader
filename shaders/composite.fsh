#version 330 compatibility

uniform sampler2D shadowtex0;

uniform sampler2D depthtex0;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;


uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform vec3 shadowLightPosition;			// position of sun/moon
uniform int worldTime;						// time of day in [0, 23999]

in vec2 texcoord;

/*
const int colortex0Format = RGB16;
*/

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

const vec3 blocklightColor = vec3(1.0, 0.5, 0.08);
const vec3 skylightColor = vec3(0.05, 0.15, 0.3);
const vec3 nightSkylightColor = vec3(0.0);
const vec3 sunlightColor = vec3(1.0);
const vec3 moonlightColor = vec3(0.03, 0.2, 0.25);
const vec3 ambientColor = vec3(0.1);

const float SHADOW_BIAS = 0.001;

const int SUNRISE_TIME  = 23215;
const int SUNSET_TIME   = 12785;
const int NOON_TIME     = 6000;
const int MIDNIGHT_TIME = 18000;
const int TIME_MAX      = 24000;

#include "lib/util.glsl"
#include "lib/constants.glsl"

#define DRAW_SHADOWS


bool isNightTime() {
	return SUNSET_TIME < worldTime && worldTime < SUNRISE_TIME;
}

vec3 getSkylightColor() {
	float factor = getTimeLerpFactor(worldTime);
	return mix(nightSkylightColor, skylightColor, factor);
}

vec3 getSunlightColor() {
	float factor = getTimeLerpFactor(worldTime);
	return mix(moonlightColor, sunlightColor, factor);
}

void main() {
	color = texture(colortex0, texcoord);
	color.rgb = pow(color.rgb, vec3(GAMMA));

	float depth = texture(depthtex0, texcoord).r;
	if (depth == 1.0) {
		discard;
	}

	vec2 lightmap = texture(colortex1, texcoord).rg; // we only need the r and g components
	vec3 encodedNormal = texture(colortex2, texcoord).rgb;
	vec3 normal = normalize((encodedNormal - 0.5) * 2.0); // we normalize to make sure it is of unit length

	vec3 lightVector = normalize(shadowLightPosition);
	vec3 worldLightVector = mat3(gbufferModelViewInverse) * lightVector;

#ifdef DRAW_SHADOWS
	vec3 NDCPos = vec3(texcoord.xy, depth) * 2.0 - 1.0;
	vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);
	vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
	vec3 shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
	vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);
	shadowClipPos.z -= SHADOW_BIAS;
	vec3 shadowNDCPos = shadowClipPos.xyz / shadowClipPos.w;
	vec3 shadowScreenPos = shadowNDCPos * 0.5 + 0.5;

	// depth comparison to determine if pixel is in shadow
	float sunlightStrength = step(shadowScreenPos.z, texture(shadowtex0, shadowScreenPos.xy).r);
#else
	float sunlightStrength = lightmap.g;
#endif // DRAW_SHADOWS

	vec3 blocklight = lightmap.r * blocklightColor;
	vec3 skylight = lightmap.g * getSkylightColor();
	vec3 ambient = ambientColor;
	vec3 sunlight = getSunlightColor() * clamp(dot(worldLightVector, normal), 0.0, 1.0) * sunlightStrength;
	color.rgb *= blocklight + skylight + ambient + sunlight;
}