#version 330

uniform mat3 N;
uniform float texUnpack;
uniform mat4 WVP;

in vec4 pos;
out vec3 wnormal;
in vec2 nor;
out vec2 texCoord;
in vec2 tex;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    wnormal = normalize(N * vec3(nor, pos.w));
    texCoord = tex * texUnpack;
    gl_Position = WVP * spos;
}

