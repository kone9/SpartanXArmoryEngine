#version 330

uniform mat3 N;
uniform mat4 W;
uniform mat4 WVP;
uniform vec3 eye;

in vec4 pos;
out vec3 wnormal;
in vec2 nor;
out vec3 wposition;
out vec3 eyeDir;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    wnormal = normalize(N * vec3(nor, pos.w));
    wposition = vec4(W * spos).xyz;
    gl_Position = WVP * spos;
    eyeDir = eye - wposition;
}

