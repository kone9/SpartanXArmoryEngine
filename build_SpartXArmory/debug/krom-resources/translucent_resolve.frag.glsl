#version 330

uniform sampler2D gbuffer0;
uniform vec2 texSize;
uniform sampler2D gbuffer1;

in vec2 texCoord;
out vec4 fragColor;

void main()
{
    vec4 accum = texelFetch(gbuffer0, ivec2(texCoord * texSize), 0);
    float revealage = 1.0 - accum.w;
    if (revealage == 0.0)
    {
        discard;
    }
    float f = texelFetch(gbuffer1, ivec2(texCoord * texSize), 0).x;
    fragColor = vec4(accum.xyz / vec3(clamp(f, 9.9999997473787516355514526367188e-05, 5000.0)), revealage);
}

