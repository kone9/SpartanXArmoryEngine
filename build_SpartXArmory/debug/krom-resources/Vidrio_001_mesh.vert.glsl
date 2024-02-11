#version 330

uniform mat3 N;
uniform float posUnpack;
uniform vec3 hdim;
uniform vec3 dim;
uniform mat4 WVP;

in vec4 pos;
out vec3 wnormal;
in vec2 nor;
out vec3 bposition;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    wnormal = normalize(N * vec3(nor, pos.w));
    bposition = ((spos.xyz * posUnpack) + hdim) / dim;
    if (dim.z == 0.0)
    {
        bposition.z = 0.0;
    }
    if (dim.y == 0.0)
    {
        bposition.y = 0.0;
    }
    if (dim.x == 0.0)
    {
        bposition.x = 0.0;
    }
    gl_Position = WVP * spos;
}

