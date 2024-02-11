#version 330

in vec3 wnormal;
out vec4 fragColor[3];

vec2 octahedronWrap(vec2 v)
{
    return (vec2(1.0) - abs(v.yx)) * vec2((v.x >= 0.0) ? 1.0 : (-1.0), (v.y >= 0.0) ? 1.0 : (-1.0));
}

float packFloatInt16(float f, uint i)
{
    uint bitsInt = i << 12u;
    uint bitsFloat = uint(f * 4095.0);
    return float(bitsInt | bitsFloat);
}

float packFloat2(float f1, float f2)
{
    return floor(f1 * 255.0) + min(f2, 0.9900000095367431640625);
}

void main()
{
    vec3 n = normalize(wnormal);
    vec3 basecol = vec3(0.800000011920928955078125);
    float roughness = 0.5;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 0.5;
    vec3 emissionCol = vec3(0.0);
    float opacity = 0.19979999959468841552734375;
    if (opacity < 0.99989998340606689453125)
    {
        discard;
    }
    n /= vec3((abs(n.x) + abs(n.y)) + abs(n.z));
    vec2 _110;
    if (n.z >= 0.0)
    {
        _110 = n.xy;
    }
    else
    {
        _110 = octahedronWrap(n.xy);
    }
    n = vec3(_110.x, _110.y, n.z);
    fragColor[0] = vec4(n.xy, roughness, packFloatInt16(metallic, 0u));
    fragColor[1] = vec4(basecol, packFloat2(occlusion, specular));
    fragColor[2] = vec4(emissionCol, 0.0);
}

