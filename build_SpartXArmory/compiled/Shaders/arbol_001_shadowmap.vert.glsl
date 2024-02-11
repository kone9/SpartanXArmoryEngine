#version 450
#include "compiled.inc"
in vec4 pos;
in vec2 tex;
out vec2 texCoord;
uniform mat4 LWVP;
uniform float texUnpack;
void main() {
	vec4 spos = vec4(pos.xyz, 1.0);
	gl_Position = LWVP * spos;
	texCoord = tex * texUnpack;
}
