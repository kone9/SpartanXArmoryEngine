#version 330

uniform mat4 LWVP;
uniform float texUnpack;

in vec4 pos;
out vec2 texCoord;
in vec2 tex;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    gl_Position = LWVP * spos;
    texCoord = tex * texUnpack;
}

