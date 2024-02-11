#version 450
#include "compiled.inc"
in vec4 pos;
in vec2 nor;
out vec3 wnormal;
out vec3 bposition;
uniform mat3 N;
uniform mat4 WVP;
uniform vec3 dim;
uniform vec3 hdim;
uniform float posUnpack;
void main() {
	vec4 spos = vec4(pos.xyz, 1.0);
	wnormal = normalize(N * vec3(nor.xy, pos.w));
	bposition = (spos.xyz * posUnpack + hdim) / dim;
	if (dim.z == 0) bposition.z = 0;
	if (dim.y == 0) bposition.y = 0;
	if (dim.x == 0) bposition.x = 0;
	gl_Position = WVP * spos;
}
