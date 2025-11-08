#version 330 compatibility

uniform sampler2D gtexture;

in vec2 texcoord;
in vec4 glcolor;

const int shadowMapResolution = 2048; // [512 1024 2048 4096]

// No RENDERTARGETS directive for shadow
// We are writing to shadowcolor0
layout(location = 0) out vec4 color;

void main() {
    color = texture(gtexture, texcoord) * glcolor;
    if (color.a < 0.1) {
        discard;
    }
}