#version 330

uniform sampler2D tex;

out vec4 fragColor;
in vec2 texCoord;

void main()
{
    fragColor = textureLod(tex, texCoord, 0.0);
}

