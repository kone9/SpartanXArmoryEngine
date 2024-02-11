#version 330

uniform sampler2D tex;

in vec2 texCoord;
out vec4 fragColor;

vec3 tonemapFilmic(vec3 color)
{
    vec3 x = max(vec3(0.0), color - vec3(0.0040000001899898052215576171875));
    return (x * ((x * 6.19999980926513671875) + vec3(0.5))) / ((x * ((x * 6.19999980926513671875) + vec3(1.7000000476837158203125))) + vec3(0.0599999986588954925537109375));
}

void main()
{
    vec2 texCo = texCoord;
    fragColor = textureLod(tex, texCo, 0.0);
    vec3 _61 = min(fragColor.xyz, vec3(32752.0));
    fragColor = vec4(_61.x, _61.y, _61.z, fragColor.w);
    vec3 _66 = tonemapFilmic(fragColor.xyz);
    fragColor = vec4(_66.x, _66.y, _66.z, fragColor.w);
}

