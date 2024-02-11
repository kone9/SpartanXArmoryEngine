#version 450
#include "compiled.inc"
in vec4 pos;
in vec2 nor;
in vec2 tex;
out vec3 wnormal;
out vec2 texCoord;
out vec3 eyeDir;
out vec3 wposition;
uniform mat3 N;
uniform mat4 WVP;
uniform float texUnpack;
uniform vec3 eye;
uniform mat4 W;
void main() {
	vec4 spos = vec4(pos.xyz, 1.0);
	wnormal = normalize(N * vec3(nor.xy, pos.w));
	texCoord = tex * texUnpack;
	wposition = vec4(W * spos).xyz;
	gl_Position = WVP * spos;
	eyeDir = eye - wposition;
}
