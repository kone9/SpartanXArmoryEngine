#version 330

uniform mat3 N;
uniform float texUnpack;
uniform mat4 WVP;

in vec4 pos;
out vec3 wnormal;
in vec2 nor;
out vec2 texCoord;
in vec2 tex;
in vec4 tang;
out mat3 TBN;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    wnormal = normalize(N * vec3(nor, pos.w));
    texCoord = tex * texUnpack;
    vec3 tangent = normalize(N * tang.xyz);
    vec3 bitangent = normalize(cross(wnormal, tangent));
    TBN = mat3(vec3(tangent), vec3(bitangent), vec3(wnormal));
    gl_Position = WVP * spos;
}

