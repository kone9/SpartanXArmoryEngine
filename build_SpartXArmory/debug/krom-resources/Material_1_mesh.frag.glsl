#version 330

uniform sampler2D ImageTexture;

in vec3 wnormal;
in vec2 texCoord;
in mat3 TBN;
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
    vec4 ImageTexture_texread_store = texture(ImageTexture, texCoord);
    vec3 ImageTexture_Color_res = ImageTexture_texread_store.xyz;
    n = (ImageTexture_Color_res * 2.0) - vec3(1.0);
    vec2 _95 = n.xy * 0.19150499999523162841796875;
    n = vec3(_95.x, _95.y, n.z);
    n = normalize(TBN * n);
    vec3 NormalMap_Normal_res = n;
    n = NormalMap_Normal_res;
    vec3 basecol = vec3(0.0034690001048147678375244140625, 0.05448000133037567138671875, 0.0409150011837482452392578125);
    float roughness = 0.1038297712802886962890625;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 0.5;
    vec3 emissionCol = vec3(0.0);
    n /= vec3((abs(n.x) + abs(n.y)) + abs(n.z));
    vec2 _141;
    if (n.z >= 0.0)
    {
        _141 = n.xy;
    }
    else
    {
        _141 = octahedronWrap(n.xy);
    }
    n = vec3(_141.x, _141.y, n.z);
    fragColor[0] = vec4(n.xy, roughness, packFloatInt16(metallic, 0u));
    fragColor[1] = vec4(basecol, packFloat2(occlusion, specular));
    fragColor[2] = vec4(emissionCol, 0.0);
}

